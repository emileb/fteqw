#include "quakedef.h"

#include "game_interface.h"

#include "keys.h"

#include "SDL.h"
#include "SDL_keycode.h"


static float look_pitch_mouse,look_pitch_abs,look_pitch_joy;
static float look_yaw_mouse,look_yaw_joy;;


int main_android (int c, const char **v);
void PortableInit(int argc,const char ** argv)
{
	LOGI("PortableInit");
    main_android( argc, argv );
}


extern int SDL_SendKeyboardKey(Uint8 state, SDL_Scancode scancode);

int PortableKeyEvent(int state, int code ,int unitcode)
{
	LOGI("PortableKeyEvent %d %d",state,code);

    if (state)
        SDL_SendKeyboardKey(SDL_PRESSED, (SDL_Scancode)code);
    else
        SDL_SendKeyboardKey(SDL_RELEASED, (SDL_Scancode) code);

	return 0;
}


void PortableAction(int state, int action)
{
	LOGI("PortableAction %d %d",state, action);

	if (( PortableGetScreenMode() == TS_MENU ) || ( PortableGetScreenMode() == TS_BLANK )  || ( PortableGetScreenMode() == TS_Y_N ))
    {
        if (action >= PORT_ACT_MENU_UP && action <= PORT_ACT_MENU_ABORT)
        {
            int sdl_code [] = { SDL_SCANCODE_UP, SDL_SCANCODE_DOWN, SDL_SCANCODE_LEFT,
                    SDL_SCANCODE_RIGHT, SDL_SCANCODE_RETURN, SDL_SCANCODE_ESCAPE, SDL_SCANCODE_Y, SDL_SCANCODE_N };

            PortableKeyEvent(state, sdl_code[action-PORT_ACT_MENU_UP], 0);

            return;
        }
    }
    else
    {
        switch (action)
        {
        case PORT_ACT_LEFT:
            if(state)
                PortableCommand("+left");
            else
                PortableCommand("-left");
        break;
        case PORT_ACT_RIGHT:
            if(state)
                PortableCommand("+right");
            else
                PortableCommand("-right");
            break;
        case PORT_ACT_FWD:
            if(state)
                PortableCommand("+forward");
            else
                PortableCommand("-forward");
            break;
        case PORT_ACT_BACK:
            if(state)
                PortableCommand("+back");
            else
                PortableCommand("-back");
            break;
        case PORT_ACT_LOOK_UP:
            if(state)
                PortableCommand("+lookup");
            else
                PortableCommand("-lookup");
            break;
        case PORT_ACT_LOOK_DOWN:
            if(state)
                PortableCommand("+lookdown");
            else
                PortableCommand("-lookdown");
            break;
        case PORT_ACT_MOVE_LEFT:
            if(state)
                PortableCommand("+moveleft");
            else
                PortableCommand("-moveleft");
            break;
        case PORT_ACT_MOVE_RIGHT:
            if(state)
                PortableCommand("+moveright");
            else
                PortableCommand("-moveright");
            break;
        case PORT_ACT_STRAFE:
            if(state)
                PortableCommand("+strafe");
            else
                PortableCommand("-strafe");
            break;
        case PORT_ACT_SPEED:
            if(state)
                PortableCommand("+speed");
            else
                PortableCommand("-speed");
            break;
        case PORT_ACT_USE:
            if(state)
                PortableCommand("+use");
            else
                PortableCommand("-use");
            break;
        case PORT_ACT_JUMP:
            if(state)
                PortableCommand("+jump");
            else
                PortableCommand("-jump");
            break;
        case PORT_ACT_ATTACK:
            if(state)
                PortableCommand("+attack");
            else
                PortableCommand("-attack");
            break;
        case PORT_ACT_UP:
            if(state)
                PortableCommand("+moveup");
            else
                PortableCommand("-moveup");
            break;
        case PORT_ACT_DOWN:
            if(state)
                PortableCommand("+movedown");
            else
                PortableCommand("-movedown");
            break;
            //TODO make fifo, possibly not thread safe!!
        case PORT_ACT_NEXT_WEP:
            if (state)
                PortableCommand("impulse 10\n");
            break;
        case PORT_ACT_PREV_WEP:
            if (state)
                PortableCommand("impulse 12\n");
            break;
        case PORT_MALICE_USE:
            if (state)
                PortableCommand("impulse 13\n");
            break;
        case PORT_MALICE_RELOAD:
            if (state)
                PortableCommand("impulse 12\n");
            break;
        case PORT_MALICE_CYCLE:
            if (state)
                PortableCommand("impulse 14\n");
            break;
        case PORT_ACT_QUICKSAVE:
            PortableKeyEvent( state, SDL_SCANCODE_F6, 0 );
            break;
        case PORT_ACT_QUICKLOAD:
            PortableKeyEvent( state, SDL_SCANCODE_F9, 0 );
            break;
        }
	}
}

char * quickCommand = 0;
void PortableCommand(const char * cmd)
{
	quickCommand = cmd;
}



extern int key_dest;
touchscreemode_t PortableGetScreenMode()
{
	if( Key_Dest_Has( kdm_centerprint | kdm_message | kdm_gmenu | kdm_nmenu | kdm_emenu ) )
	{
		return TS_MENU;
	}
	else
	{
		return TS_GAME;
	}
}


void PortableAutomapControl(float zoom, float x, float y)
{

}

void PortableBackButton()
{
    LOGI("Back button");
    PortableKeyEvent(1, SDL_SCANCODE_ESCAPE,0 );
    PortableKeyEvent(0, SDL_SCANCODE_ESCAPE, 0);
}

// =================== FORWARD and SIDE MOVMENT ==============

float forwardmove, sidemove; //Joystick mode

void PortableMoveFwd(float fwd)
{
	if (fwd > 1)
		fwd = 1;
	else if (fwd < -1)
		fwd = -1;

	forwardmove = fwd;
}

void PortableMoveSide(float strafe)
{
	if (strafe > 1)
		strafe = 1;
	else if (strafe < -1)
		strafe = -1;

	sidemove = strafe;
}

void PortableMove(float fwd, float strafe)
{
	PortableMoveFwd(fwd);
	PortableMoveSide(strafe);
}

//======================================================================

//Look up and down

void PortableLookPitch(int mode, float pitch)
{
	switch(mode)
	{
	case LOOK_MODE_MOUSE:
		look_pitch_mouse += pitch;
		break;
	case LOOK_MODE_JOYSTICK:
		look_pitch_joy = pitch;
		break;
	}
}

//left right

void PortableLookYaw(int mode, float yaw)
{
	switch(mode)
	{
	case LOOK_MODE_MOUSE:
		look_yaw_mouse += yaw;
		break;
	case LOOK_MODE_JOYSTICK:
		look_yaw_joy = yaw;
		break;
	}
}

/////////////////////
// Movement handling
////

void IN_Move_Android (float *movements, int pnum, float frametime)
{
	if (quickCommand)
	{
		Cmd_ExecuteString(quickCommand, RESTRICT_LOCAL);
		quickCommand = 0;
	}

	if( !movements )
		return;

	movements[0]  += forwardmove * cl_forwardspeed.value;
	movements[1]  += sidemove   * cl_forwardspeed.value;

	//LOGI("movements[0] = %f, movements[1] = %f",movements[0],movements[1]);

	V_StopPitchDrift (&cl.playerview[pnum]);

	cl.playerview[pnum].viewanglechange[PITCH] -= look_pitch_mouse * 150;
	look_pitch_mouse = 0;
	cl.playerview[pnum].viewanglechange[PITCH] += look_pitch_joy * 6;


	cl.playerview[pnum].viewanglechange[YAW] += look_yaw_mouse * 300;
	look_yaw_mouse = 0;
	cl.playerview[pnum].viewanglechange[YAW] += look_yaw_joy * 6;


	if (cl.playerview[pnum].viewanglechange[PITCH] > 80)
		cl.playerview[pnum].viewanglechange[PITCH] = 80;
	if (cl.playerview[pnum].viewanglechange[PITCH]< -70)
		cl.playerview[pnum].viewanglechange[PITCH] = -70;
}

