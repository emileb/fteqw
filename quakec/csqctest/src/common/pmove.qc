/*

WARNING: This entire file is pretty much GPLed.
If you want to release your csqc mod free from the GPL, do not define OWNPLAYERPHYSICS, and remove this file from your progs.src

*/

#ifdef OWNPLAYERPHYSICS

/*
be very careful about the fields/globals that are read/written in this code.
Using any that are changed elsewhere can and will result in prediction errors.
Any fields that are expected to persist need to be added to csqc code to revert them.
Any fields that are read need to be the same between csqc and ssqc code somehow. Changing such fields will result in brief errors.
*/


#define movevars_stepheight 22
#define movevars_friction 4
#define movevars_gravity 800
#define movevars_accelerate 10
#define movevars_stopspeed 100
#define movevars_maxspeed 320
#define movevars_jumpheight 270

.float pmove_flags;

#ifdef HAVE_DOTGRAVITY
.float gravity;
#endif
.entity groundentity;

enumflags
{
	PMF_JUMP_HELD,
	PMF_RESERVED,
	PMF_ONGROUND
};

static void(entity tother) dotouch =
{
	entity oself;
	if (tother.touch == __NULL__)
		return;

	oself = self;
	
	other = self;
	self = tother;

	self.touch();

	self = oself;
};

//this function 'bounces' off any surfaces that were hit
void(vector surfnorm) PMove_Rebound =
{
	float v;
	v = self.velocity*surfnorm;
	self.velocity = self.velocity - surfnorm*(v);

	if (surfnorm_z > 0.7)
	{	//if we hit a ground plane then we're now on the ground.
		self.pmove_flags |= PMF_ONGROUND;
		self.groundentity = trace_ent;
	}
};

void(void) PMove_Move =	//move forwards (preferably on the level) (does step ups)
{
	vector dest;
	vector saved_plane_normal;
	float stepped;
	float movetime;
	float attempts;

	//we need to bounce off surfaces (in order to slide along them), so we need at 2 attempts
	for (attempts = 3, movetime = input_timelength; movetime>0 && attempts; attempts--)
	{
		dest = self.origin + self.velocity*movetime;
		tracebox(self.origin, self.mins, self.maxs, dest, false, self);	//try going straight there
		self.origin = trace_endpos;

		if (trace_fraction < 1)
		{
			saved_plane_normal = trace_plane_normal;

			movetime -= movetime * trace_fraction;

			if (movetime)
			{
				//step up if we can
				trace_endpos = self.origin;
				trace_endpos_z += movevars_stepheight;
				tracebox(self.origin, self.mins, self.maxs, trace_endpos, false, self);
				stepped = trace_endpos_z - self.origin_z;

				dest = trace_endpos + self.velocity*movetime;
				dest_z = trace_endpos_z;
				//move forwards
				tracebox(trace_endpos, self.mins, self.maxs, dest, false, self);

				//if we got anywhere, make this raised-step move count
				if (trace_fraction != 0)
				{
					movetime -= movetime * trace_fraction;
					self.pmove_flags &= ~PMF_ONGROUND;
					if (trace_fraction < 1)
						PMove_Rebound(trace_plane_normal);
			
					//move down
					dest = trace_endpos;
					dest_z -= stepped+1;
					tracebox(trace_endpos, self.mins, self.maxs, dest, false, self);
					if (trace_fraction < 1)
						PMove_Rebound(trace_plane_normal);

					self.origin = trace_endpos;


					continue;
				}
			}
			
			//stepping failed, just bounce off
			PMove_Rebound(saved_plane_normal);

			dotouch(trace_ent);
		}
		else
			break;
	}
};
/*
void(vector dest) PMove_StepMove =
{
	//we hit something...

	//step up
	src = trace_endpos;
	trace_endpos_z += movevars_stepheight;
	tracebox(src, self.mins, self.maxs, dest, false, self);
	stepped = trace_endpos_z - src_z;
	dest_z += stepped;

	//move forwards
	tracebox(trace_endpos, self.mins, self.maxs, dest, false, self);

	//move down
	dest_z -= stepped;
	tracebox(trace_endpos, self.mins, self.maxs, dest, false, self);
}
*/
void() PMove_ApplyFriction =
{
	float newspeed, oldspeed;
	oldspeed = vlen(self.velocity);
	if (oldspeed < 1)
	{
		self.velocity = '0 0 0';
		return;
	}
	
	//calculate what their new speed should be
	newspeed = oldspeed - oldspeed*movevars_friction*input_timelength;

	//and slow them
	if (newspeed < 0)
		newspeed = 0;
	self.velocity = self.velocity * (newspeed/oldspeed);
};

void(vector wishdir, float wishspeed, float accel) PMove_Accelerate =
{
	float addspeed, accelspeed;
	float d;
	d = self.velocity*wishdir;
	addspeed = wishspeed - (d);
	if (addspeed <= 0)
		return;
	accelspeed = accel*input_timelength*wishspeed;
	if (accelspeed > addspeed)
		accelspeed = addspeed;

	self.velocity = self.velocity + accelspeed*wishdir;
};

void() PMove_InAirAccelerate =
{
	vector hforward;
	vector hright;
	vector desireddir;
	float desiredspeed;

	hforward = v_forward;
	hforward_z = 0;
	hforward = normalize(hforward);
	hright = v_right;
	hright_z = 0;
	hright = normalize(hright);

	desireddir = hforward*input_movevalues_x + hright*input_movevalues_y;
	desiredspeed = vlen(desireddir);
	desireddir = normalize(desireddir);

	if (desiredspeed > movevars_maxspeed)
		desiredspeed = movevars_maxspeed;

	if (self.pmove_flags & PMF_ONGROUND)
	{
		if (input_buttons & 2)
		{
			if (!(self.pmove_flags & PMF_JUMP_HELD))
			{
				self.velocity_z += movevars_jumpheight;
				self.pmove_flags |= PMF_ONGROUND;
			}
		}
	}

	if (self.pmove_flags & PMF_ONGROUND)
	{
		PMove_ApplyFriction();
		PMove_Accelerate(desireddir, desiredspeed, movevars_accelerate);
	}
	else
	{
		//there's no friction in air...
		if (desiredspeed > 30)
			desiredspeed = 30;
		PMove_Accelerate(desireddir, desiredspeed, movevars_accelerate);

#ifdef HAVE_DOTGRAVITY
		if (self.gravity)
			self.velocity_z -= self.gravity * movevars_gravity * input_timelength;
		else
#endif
			self.velocity_z -= movevars_gravity * input_timelength;
	}
};

void() PMove_NoclipAccelerate =
{
	vector desireddir;
	float desiredspeed;

	desireddir = v_forward*input_movevalues_x + v_right*input_movevalues_y+v_up*input_movevalues_z;
	desiredspeed = vlen(desireddir);
	desireddir = normalize(desireddir);

	PMove_ApplyFriction();
	PMove_Accelerate(desireddir, desiredspeed, movevars_accelerate);
};

void() PMove_Categorise =
{
	//if we're moving up, we're not on the ground
	if (self.velocity_z > 0)
	{
		self.pmove_flags &= ~PMF_ONGROUND;
	}
	else
	{
		//don't know, maybe we are, maybe we're not
		tracebox(self.origin, self.mins, self.maxs, self.origin-'0 0 1', false, self);
		if (trace_fraction == 1 || trace_plane_normal_z < 0.7)
		{
			self.pmove_flags &= ~PMF_ONGROUND;
		}
		else
		{
			self.pmove_flags |= PMF_ONGROUND;
			self.groundentity = trace_ent;
		}
	}
};

float roundcoordf(float f)
{	//round this coord like the networking will... ish...
	//coord rounding is often client-specific. which makes life fun.
	return rint(f*8)/8;
}
vector roundcoordv(vector v)
{
	return [
		roundcoordf(v_x),
		roundcoordf(v_y),
		roundcoordf(v_z)
	];
}
vector truncv(vector v)
{
	return v & v;
}
static void Pmove_Nudge(void)
{
	self.velocity = truncv(self.velocity);
	vector test, org = roundcoordv(self.origin);

	static float offsets[] = {0, -1./8, 1./8, -2./8, 2./8};
	for (float z = 0; z < offsets.length; z++)	
	{
		test.z = org.z + offsets[z];
		for (float y = 0; y < offsets.length; y++)	
		{
			test.y = org.y + offsets[y];
			for (float x = 0; x < offsets.length; x++)	
			{
				test.x = org.x + offsets[x];
				tracebox(test, self.mins, self.maxs, test, false, self);
				if (!trace_startsolid)
				{	//okay, that'll do
					self.origin = test;
					return;
				}
			}
		}
	}
	self.origin = org;
};

void(entity ent) PMove =
{
	self = ent;
	makevectors(input_angles);

	Pmove_Nudge();

	if (!(input_buttons & PMF_JUMP_HELD))
		self.pmove_flags &= ~PMF_JUMP_HELD;

	PMove_Categorise();

	self.movetype = MOVETYPE_WALK;

	if (input_timelength >= 0)
	{
		switch(self.movetype)
		{
		case MOVETYPE_WALK:
			PMove_InAirAccelerate();
			PMove_Move();
			break;
		case MOVETYPE_FLY:
			PMove_NoclipAccelerate();
			PMove_Move();
			break;
		case MOVETYPE_NOCLIP:
			PMove_NoclipAccelerate();
			self.origin += self.velocity*input_timelength;
			break;
		case MOVETYPE_NONE:
			break;
		}

		touchtriggers(self);
	}
	else print(sprintf("timelength %g\n", input_timelength));

	if (self.pmove_flags & PMF_ONGROUND)
		self.flags |= FL_ONGROUND;
	else
		self.flags &= ~FL_ONGROUND;
};

#endif
