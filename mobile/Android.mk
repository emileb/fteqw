LOCAL_PATH:= $(call my-dir)/../

include $(CLEAR_VARS)

LOCAL_MODULE := fteqw_dev

LOCAL_CFLAGS := -DGLQUAKE -DLIBVORBISFILE_STATIC  -Wno-write-strings -DFTEQW -DENGINE_NAME=\"fteqw\"
LOCAL_CFLAGS += -Wall -Wno-pointer-sign -Wno-unknown-pragmas -Wno-format-zero-length -Wno-strict-aliasing
LOCAL_CFLAGS += -Dstrnicmp=strncasecmp -Dstricmp=strcasecmp -fsigned-char

LOCAL_CPPFLAGS :=  $(LOCAL_CFLAGS)  -fpermissive

BASE_DIR := engine

LOCAL_C_INCLUDES :=     $(SDL_INCLUDE_PATHS)  \
                        $(TOP_DIR) \
                        $(TOP_DIR)/MobileTouchControls \
                        $(TOP_DIR)/MobileTouchControls/libpng \
                        $(TOP_DIR)/AudioLibs_OpenTouch/liboggvorbis/include \
                        $(TOP_DIR)/AudioLibs_OpenTouch/ \
                        $(TOP_DIR)/Clibs_OpenTouch \
                        $(TOP_DIR)/Clibs_OpenTouch/jpeg8d \
                        $(TOP_DIR)/Clibs_OpenTouch/freetype2-android/include \
                        $(TOP_DIR)/Clibs_OpenTouch/quake \
$(LOCAL_PATH)/$(BASE_DIR)/client \
$(LOCAL_PATH)/$(BASE_DIR)/gl \
$(LOCAL_PATH)/$(BASE_DIR)/d3d \
$(LOCAL_PATH)/$(BASE_DIR)/server \
$(LOCAL_PATH)/$(BASE_DIR)/common \
$(LOCAL_PATH)/$(BASE_DIR)/http \
$(LOCAL_PATH)/$(BASE_DIR)/qclib \
$(LOCAL_PATH)/$(BASE_DIR)/nacl \
$(LOCAL_PATH)/$(BASE_DIR)/botlib \

#$(LOCAL_PATH)/$(BASE_DIR)/libs \

# engine/gl/gl_vidsdl.c \

LOCAL_SRC_FILES := \
    mobile/game_interface.c \
    ../../Clibs_OpenTouch/quake/android_jni.cpp \
    ../../Clibs_OpenTouch/quake/touch_interface.cpp \
    engine/client/sys_sdl.c \
    engine/client/snd_al.c \
    engine/client/snd_sdl.c \
    engine/client/in_sdl.c \
    engine/client/cd_sdl.c \
    engine/gl/gl_vidsdl.c \
    engine/common/net_ssl_gnutls.c \
    engine/common/cmd.c \
    engine/common/com_mesh.c \
    engine/common/common.c \
    engine/common/crc.c \
    engine/common/cvar.c \
    engine/common/fs.c \
    engine/common/fs_dzip.c \
    engine/common/fs_pak.c \
    engine/common/fs_stdio.c \
    engine/common/fs_xz.c \
    engine/common/fs_zip.c \
    engine/common/gl_q2bsp.c \
    engine/common/huff.c \
    engine/common/log.c \
    engine/common/mathlib.c \
    engine/common/md4.c \
    engine/common/net_chan.c \
    engine/common/net_ice.c \
    engine/common/net_wins.c \
    engine/common/plugin.c \
    engine/common/pmove.c \
    engine/common/pmovetst.c \
    engine/common/pr_bgcmd.c \
    engine/common/q1bsp.c \
    engine/common/q2pmove.c \
    engine/common/q3common.c \
    engine/common/qvm.c \
    engine/common/sha1.c \
    engine/common/translate.c \
    engine/common/zone.c \
    engine/client/pr_skelobj.c \
    engine/client/m_download.c \
    engine/client/net_master.c \
    engine/gl/gl_heightmap.c \
    engine/gl/gl_hlmdl.c \
    engine/gl/gl_model.c \
    engine/server/net_preparse.c \
    engine/server/pr_cmds.c \
    engine/server/pr_lua.c \
    engine/server/pr_q1qvm.c \
    engine/server/savegame.c \
    engine/server/sv_ccmds.c \
    engine/server/sv_chat.c \
    engine/server/sv_cluster.c \
    engine/server/sv_demo.c \
    engine/server/sv_ents.c \
    engine/server/sv_init.c \
    engine/server/sv_main.c \
    engine/server/sv_master.c \
    engine/server/sv_move.c \
    engine/server/sv_mvd.c \
    engine/server/sv_nchan.c \
    engine/server/sv_phys.c \
    engine/server/sv_rankin.c \
    engine/server/sv_send.c \
    engine/server/sv_sql.c \
    engine/server/sv_user.c \
    engine/server/svq2_ents.c \
    engine/server/svq2_game.c \
    engine/server/svq3_game.c \
    engine/server/world.c \
    engine/qclib/comprout.c \
    engine/qclib/hash.c \
    engine/qclib/initlib.c \
    engine/qclib/pr_edict.c \
    engine/qclib/pr_exec.c \
    engine/qclib/pr_multi.c \
    engine/qclib/qcc_cmdlib.c \
    engine/qclib/qcc_pr_comp.c \
    engine/qclib/qcc_pr_lex.c \
    engine/qclib/qccmain.c \
    engine/qclib/qcd_main.c \
    engine/qclib/qcdecomp.c \
    engine/http/httpclient.c \
    engine/client/cl_cam.c \
    engine/client/cl_cg.c \
    engine/client/cl_demo.c \
    engine/client/cl_ents.c \
    engine/client/cl_ignore.c \
    engine/client/cl_input.c \
    engine/client/cl_main.c \
    engine/client/cl_parse.c \
    engine/client/cl_pred.c \
    engine/client/cl_screen.c \
    engine/client/cl_tent.c \
    engine/client/cl_ui.c \
    engine/client/clq2_cin.c \
    engine/client/clq2_ents.c \
    engine/client/clq3_parse.c \
    engine/client/console.c \
    engine/client/fragstats.c \
    engine/client/image.c \
    engine/client/in_generic.c \
    engine/client/keys.c \
    engine/client/m_items.c \
    engine/client/m_master.c \
    engine/client/m_mp3.c \
    engine/client/m_multi.c \
    engine/client/m_options.c \
    engine/client/m_script.c \
    engine/client/m_native.c \
    engine/client/m_single.c \
    engine/client/menu.c \
    engine/client/p_classic.c \
    engine/client/p_null.c \
    engine/client/p_script.c \
    engine/client/pr_clcmd.c \
    engine/client/pr_csqc.c \
    engine/client/pr_menu.c \
    engine/client/r_2d.c \
    engine/client/r_d3.c \
    engine/client/r_part.c \
    engine/client/r_partset.c \
    engine/client/r_surf.c \
    engine/client/renderer.c \
    engine/client/renderque.c \
    engine/client/roq_read.c \
    engine/client/sbar.c \
    engine/client/skin.c \
    engine/client/snd_dma.c \
    engine/client/snd_mem.c \
    engine/client/snd_mix.c \
    engine/client/snd_mp3.c \
    engine/client/snd_ov.c \
    engine/client/textedit.c \
    engine/client/valid.c \
    engine/client/vid_headless.c \
    engine/client/view.c \
    engine/client/wad.c \
    engine/client/zqtp.c \
    engine/gl/gl_alias.c \
    engine/gl/gl_font.c \
    engine/gl/gl_ngraph.c \
    engine/gl/gl_rlight.c \
    engine/gl/gl_shader.c \
    engine/gl/gl_shadow.c \
    engine/gl/gl_warp.c \
    engine/gl/ltface.c \
    engine/gl/gl_backend.c \
    engine/gl/gl_bloom.c \
    engine/gl/gl_draw.c \
    engine/gl/gl_rmain.c \
    engine/gl/gl_rmisc.c \
    engine/gl/gl_rsurf.c \
    engine/gl/gl_screen.c \
    engine/gl/gl_vidcommon.c \
    engine/gl/glmod_doom.c \
    engine/vk/vk_backend.c \
    engine/vk/vk_init.c \


LOCAL_LDLIBS := -lEGL -ldl -llog -lOpenSLES -lz -lGLESv1_CM
LOCAL_STATIC_LIBRARIES := sigc libzip libpng logwritter  freetype2-static libjpeg
LOCAL_SHARED_LIBRARIES := touchcontrols SDL2 SDL2_mixer core_shared

include $(BUILD_SHARED_LIBRARY)



include 
