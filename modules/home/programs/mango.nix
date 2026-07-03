{ inputs, pkgs, ... }:
{
    imports = [
        inputs.mangowm.hmModules.mango
    ];
    wayland.windowManager.mango = {
        enable = true;
        systemd.enable = true;
        settings = {
            # Window effect
            blur = 0;
            blur_layer = 0;
            blur_optimized = 1;
            blur_params = {
                num_passes = 2;
                radius = 5;
                noise = 0.02;
                brightness = 0.9;
                contrast = 0.9;
                saturation = 1.2;
            };

            shadows = 0;
            layer_shadows = 0;
            shadow_only_floating = 1;
            shadows_size = 10;
            shadows_blur = 15;
            shadows_position = {
                x = 0;
                y = 0;
            };
            shadowscolor = "0x000000ff";

            border_radius = 0;
            no_radius_when_single = 0;
            focused_opacity = 1.0;
            unfocused_opacity = 1.0;

            # Animation Configuration(support type:zoom,slide)
            # tag_animation_direction: 1-horizontal,0-vertical
            animations = 1;
            layer_animations = 0;
            animation_type = {
                open = "slide";
                close = "slide";
            };
            animation_fade_in = 1;
            animation_fade_out = 1;
            tag_animation_direction = 1;
            zoom_initial_ratio = 0.4;
            zoom_end_ratio = 0.8;
            fadein_begin_opacity = 0.5;
            fadeout_begin_opacity = 0.8;
            animation_duration = {
                tag = 350;
                move = 350;
                open = 200;
                close = 200;
                focus = 0;
            };
            animation_curve = {
                open = "0.46,1.0,0.29,1";
                move = "0.46,1.0,0.29,1";
                tag = "0.46,1.0,0.29,1";
                close = "0.08,0.92,0,1";
                focus = "0.46,1.0,0.29,1";
                opafadeout = "0.5,0.5,0.5,0.5";
                opafadein = "0.46,1.0,0.29,1";
            };

            # Scroller Layout Setting
            scroller = {
                structs = 20;
                default_proportion = 0.8;
                focus_center = 0;
                prefer_center = 0;
                default_proportion_single = 1.0;
                proportion_preset = "0.5,0.8,1.0";
            };
            edge_scroller_pointer_focus = 1;

            # Master-Stack Layout Setting
            new_is_master = 1;
            default_mfact = 0.55;
            default_nmaster = 1;
            smartgaps = 1;


            # Dwindle Layout Setting
            dwindle = {
                smart_split = 0;
                drop_simple_split = 1;
                manual_split = 0;
                hsplit = 1;
                vsplit = 1;
                preserve_split = 0;
            };

            # Overview Setting
            hotarea_size = 10;
            enable_hotarea = 0;
            ov_tab_mode = 0;
            overviewgappi = 5;
            overviewgappo = 30;

            # Misc
            no_border_when_single = 0;
            axis_bind_apply_timeout = 100;
            focus_on_activate = 0;
            idleinhibit_ignore_visible = 0;
            sloppyfocus = 0;
            warpcursor = 1;
            cursor_hide_timeout = 5;
            cursor_hide_on_keypress = 1;
            focus_cross_monitor = 0;
            focus_cross_tag = 0;
            enable_floating_snap = 0;
            snap_distance = 30;
            drag_tile_to_tile = 1;
            drag_tile_small = 1;
            scratchpad_cross_monitor = 1;
            single_scratchpad = 1;
            xwayland_persistence = 1;
            allow_shortcuts_inhibit = 1;

            # keyboard
            repeat = {
                rate = 50;
                delay = 200;
            };
            numlockon = 0;
            xkb_rules = {
                layout = "us,ara";
                options = "grp:alt_space_toggle,grp_led:caps";
            };


            # Trackpad
            # need relogin to make it apply
            disable_trackpad = 0;
            tap_to_click = 1;
            tap_and_drag = 1;
            drag_lock = 1;
            trackpad_natural_scrolling = 0;
            disable_while_typing = 1;
            left_handed = 0;
            middle_button_emulation = 0;
            swipe_min_threshold = 1;

            # mouse
            # need relogin to make it apply
            mouse_natural_scrolling=0;

            # Appearance
            gappih = 5;
            gappiv = 5;
            gappoh = 0;
            gappov = 0;
            scratchpad_width_ratio = 0.6;
            scratchpad_height_ratio = 0.7;
            borderpx = 2;
            cursor_size = 24;
            cursor_theme = "Adwaita";
            rootcolor = "0x2e3440ff";
            bordercolor = "0x4c566aff";
            dropcolor = "0x4c566a55";
            splitcolor = "0xb74e58ff";
            focuscolor = "0x5e81acff";
            maximizescreencolor = "0x97b67cff";
            urgentcolor = "0xb74e58ff";
            scratchpadcolor = "0x5e81acff";
            globalcolor = "0x80b3b2ff";
            overlaycolor = "0x14a57cff";

            # layout support:
            # tile,scroller,grid,deck,monocle,center_tile,vertical_tile,vertical_scroller
            tagrule = [
                "id:1,layout_name:tile"
                "id:2,layout_name:tile"
                "id:3,layout_name:tile"
                "id:4,layout_name:tile"
                "id:5,layout_name:tile"
                "id:6,layout_name:tile"
                "id:7,layout_name:tile"
                "id:8,layout_name:tile"
                "id:9,layout_name:tile"
            ];

            bind = [
                "SUPER+SHIFT,R,reload_config"
                "SUPER+SHIFT,C,killclient"

                # switch window focus
                "SUPER,J,focusstack,next"
                "SUPER,K,focusstack,previous"
                "SUPER,Up,focusdir,up"
                "SUPER,Down,focusdir,down"
                "SUPER,Left,focusdir,left"
                "SUPER,Right,focusdir,right"
                "SUPER,Tab,view,-1"
                "SUPER,Space,zoom"

                # swap window
                "SUPER+SHIFT,K,exchange_client,up"
                "SUPER+SHIFT,J,exchange_client,down"
                "SUPER+SHIFT,H,exchange_client,left"
                "SUPER+SHIFT,L,exchange_client,right"

                # switch window status
                "SUPER,S,toggleglobal,"
                "SUPER+SHIFT,Tab,toggleoverview,"
                "SUPER+SHIFT,Space,togglefloating,"
                "SUPER,F,togglefullscreen,"
                "SUPER+ALT,F,togglefakefullscreen,"
                "SUPER+SHIFT,F,togglemaximizescreen,"
                "SUPER+CTRL,F,toggleoverlay,"
                "SUPER+CTRL,P,minimized,"
                "SUPER+ALT,P,restore_minimized"
                "SUPER+SHIFT,P,toggle_scratchpad"
                "SUPER,P,toggle_named_scratchpad,terminal-scratchpad,none,terminal -a terminal-scratchpad -w 840x560"

                # scroller layout
                "SUPER+SHIFT,S,set_proportion,1.0"
                "SUPER+ALT,S,switch_proportion_preset,"
                "SUPER+CTRL+ALT,H,scroller_stack,left"
                "SUPER+CTRL+ALT,L,scroller_stack,right"
                "SUPER+CTRL+ALT,K,scroller_stack,up"
                "SUPER+CTRL+ALT,J,scroller_stack,down"

                # dwindle layout (manual split mode)
                "SUPER+SHIFT,D,dwindle_toggle_split_direction"

                # switch layout
                "SUPER,T,switch_layout"
                "SUPER+SHIFT,T,setlayout,tile"

                # tag switch
                "SUPER+SHIFT,Left,viewtoleft,0"
                "SUPER+CTRL+SHIFT,Left,viewtoleft_have_client,0"
                "SUPER+SHIFT,Right,viewtoright,0"
                "SUPER+CTRL+SHIFT,Right,viewtoright_have_client,0"
                "SUPER+ALT,Left,tagtoleft,0"
                "SUPER+ALT,Right,tagtoright,0"

                "SUPER,1,view,1,0"
                "SUPER,2,view,2,0"
                "SUPER,3,view,3,0"
                "SUPER,4,view,4,0"
                "SUPER,5,view,5,0"
                "SUPER,6,view,6,0"
                "SUPER,7,view,7,0"
                "SUPER,8,view,8,0"
                "SUPER,9,view,9,0"

                # tag: move client to the tag and focus it
                # tagsilent: move client to the tag and not focus it
                "SUPER+SHIFT,1,tag,1,0"
                "SUPER+SHIFT,2,tag,2,0"
                "SUPER+SHIFT,3,tag,3,0"
                "SUPER+SHIFT,4,tag,4,0"
                "SUPER+SHIFT,5,tag,5,0"
                "SUPER+SHIFT,6,tag,6,0"
                "SUPER+SHIFT,7,tag,7,0"
                "SUPER+SHIFT,8,tag,8,0"
                "SUPER+SHIFT,9,tag,9,0"

                # monitor switch
                "SUPER,Comma,focusmon,left"
                "SUPER,Period,focusmon,right"
                "SUPER+SHIFT,Comma,tagmon,left"
                "SUPER+SHIFT,Period,tagmon,right"

                # movewin
                "SUPER+CTRL+SHIFT,Up,movewin,+0,-50"
                "SUPER+CTRL+SHIFT,Down,movewin,+0,+50"
                "SUPER+CTRL+SHIFT,Left,movewin,-50,+0"
                "SUPER+CTRL+SHIFT,Right,movewin,+50,+0"

                # resizewin
                "SUPER+CTRL,K,resizewin,+0,-50"
                "SUPER+CTRL,J,resizewin,+0,+50"
                "SUPER,H,resizewin,-50,+0"
                "SUPER,L,resizewin,+50,+0"

                "SUPER,Return,spawn,terminal"
                "SUPER,E,spawn,emacsclient -nca emacs"
                "NONE,Menu,spawn,menu-handler"
                "SUPER,M,spawn,menu-handler"
                "SUPER,R,spawn,menu-handler apps"
                "SUPER,Q,spawn,menu-handler system-actions"
                "NONE,Print,spawn,menu-handler screenshot"
                "ALT,Print,spawn,menu-handler screen-recording"
                "CTRL+ALT,Print,spawn,menu-handler screen-recording stop"
                "SUPER,I,spawn,menu-handler input-handler"
                "SUPER,O,spawn,menu-handler clipboard-history"
                "SUPER+SHIFT,O,spawn,menu-handler recent-files"
                "SUPER,Backslash,spawn,menu-handler notifications clear"
                "SUPER+SHIFT,Backslash,spawn,menu-handler notifications dnd"
                "NONE,XF86PowerOff,spawn,menu-handler system-actions"
                "NONE,XF86Display,spawn,menu-handler display-profiles"
            ];

            bindl = [
                "NONE,XF86Eject,spawn,eject -T"
                "NONE,XF86AudioRaiseVolume,spawn,audioctl output 5%+"
                "NONE,XF86AudioLowerVolume,spawn,audioctl output 5%-"
                "NONE,XF86AudioMute,spawn,audioctl output toggle"
                "NONE,XF86AudioMicMute,spawn,audioctl input toggle"
                "SUPER,Equal,spawn,audioctl output 5%+"
                "SUPER,Minus,spawn,audioctl output 5%-"
                "SUPER,Backspace,spawn,audioctl output toggle"
                "SUPER+CTRL,Backspace,spawn,audioctl input toggle"
                "NONE,XF86AudioNext,spawn,playerctl next"
                "NONE,XF86AudioPrev,spawn,playerctl previous"
                "NONE,XF86AudioPlay,spawn,playerctl play-pause"
                "NONE,XF86AudioMedia,spawn,playerctl play-pause"
                "SUPER+SHIFT,Equal,spawn,playerctl next"
                "SUPER+SHIFT,Minus,spawn,playerctl previous"
                "SUPER+SHIFT,Backspace,spawn,playerctl play-pause"
                "NONE,XF86MonBrightnessUp,spawn,screenlightctl 10%+"
                "NONE,XF86MonBrightnessDown,spawn,screenlightctl 10%-"
            ];

            windowrule = [
                "isterm:1,appid:foot"
                "isterm:1,appid:footclient"
                "isterm:1,isnamedscratchpad:1,width:840,height:560,appid:terminal-scratchpad"
                "isterm:1,isfloating:1,width:840,height:560,appid:terminal-floating"
            ];

            # layer rule
            layerrule = [
                "animation_type_open:slide,layer_name:launcher"
                "animation_type_close:slide,layer_name:launcher"
            ];

            # Mouse Button Bindings
            # btn_left and btn_right can't bind NONE mod key
            mousebind = [
                "SUPER,btn_left,moveresize,curmove"
                "SUPER,btn_middle,togglemaximizescreen,0"
                "SUPER,btn_right,moveresize,curresize"
            ];

            # Axis Bindings
            axisbind = [
                "SUPER,Up,viewtoleft_have_client"
                "SUPER,Down,viewtoright_have_client"
            ];

            env = [
                "SDL_VIDEODRIVER,wayland"
                "CLUTTER_BACKEND,wayland"
                "QT_QPA_PLATFORM,wayland;xcb"
                "ELM_DISPLAY,wl"
                "MOZ_ENABLE_WAYLAND,1"
                "NO_AT_BRIDGE,1"
                "_JAVA_AWT_WM_NONREPARENTING,1"
                "AWT_TOOLKIT,MToolkit wmname LG3D"
            ];
        };
    };
}
