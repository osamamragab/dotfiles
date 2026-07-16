{
    inputs,
    pkgs,
    lib,
    config,
    ...
}:
{
    imports = [
        inputs.noctalia.homeModules.default
    ];

    home.packages = with pkgs; [
        gpu-screen-recorder # required for noctalia/screen_recorder plugin.
        hyprpicker # required for noctalia/color_picker plugin.
    ];

    programs.noctalia = {
        enable = true;
        settings = {
            desktop_widgets.enabled = false;
            nightlight.enabled = true;
            location = {
                auto_locate = false;
                address = "Cairo, Egypt";
            };
            theme = {
                mode = "dark";
                source = "builtin";
                builtin = "Nord";
                wallpaper_scheme = "soft";
            };
            audio = {
                enable_sounds = true;
                enable_overdrive = true;
                sound_volume = 1.0;
            };
            dock = {
                enabled = false;
                shadow = false;
                reserve_space = false;
                show_dots = true;
                smart_auto_hide = true;
                launcher_position = "end";
            };
            shell = {
                font_family = "monospace";
                date_format = "%A, %F";
                session.grid = true;
                panel = {
                    shadow = false;
                    open_near_click_control_center = true;
                    open_near_click_session = true;
                    transparency_mode = "soft";
                };
                screenshot = {
                    confirm_region = true;
                    directory = "${config.xdg.userDirs.pictures}/screenshots";
                    filename_pattern = "screenshot_%Y%m%d-%H%M%S";
                };
                launcher = {
                    provider_prefix = "/";
                    providers = {
                        calculator.prefix = "=";
                    };
                };
            };
            osd = {
                position_vertical = "top_right";
            };
            wallpaper = {
                enabled = true;
                fill_mode = "stretch";
                fill_color = "surface";
                directory = "${config.xdg.userDirs.pictures}/wallpapers";
                default.path = "${config.programs.noctalia.settings.wallpaper.directory}/default.png";
            };
            keybinds = {
                cancel = [
                    "Escape"
                    "Ctrl+c"
                ];
                down = [
                    "Down"
                    "Ctrl+j"
                ];
                left = [
                    "Left"
                    "Ctrl+h"
                ];
                right = [
                    "Right"
                    "Ctrl+l"
                ];
                tab_next = [
                    "Tab"
                    "Ctrl+n"
                ];
                tab_previous = [
                    "Shift+ISO_Left_Tab"
                    "Ctrl+p"
                ];
                up = [
                    "Up"
                    "Ctrl+k"
                ];
            };
            idle = {
                pre_action_fade_seconds = 10;
                behavior_order = [
                    "lock"
                    "screen-off"
                    "lock-and-suspend"
                ];
                behavior = {
                    lock = {
                        enabled = true;
                        action = "lock";
                        timeout = 10 * 60;
                    };
                    screen-off = {
                        enabled = true;
                        action = "screen_off";
                        timeout = 11 * 60;
                    };
                    lock-and-suspend = {
                        enabled = true;
                        action = "lock_and_suspend";
                        timeout = 15 * 60;
                    };
                };
            };
            widget = {
                volume.show_label = false;
                network.show_label = false;
                bluetooth.show_label = false;
                cat = {
                    type = "noctalia/bongocat:cat";
                    tappy_mode = true;
                    audio_spectrum = true;
                    use_mpris_filter = true;
                };
                clock = {
                    capsule_radius = 4;
                    capsule_padding = 10;
                    format = "{:%a %H:%M}";
                    tooltip_format = "{:%d %b (W%U)}";
                };
                battery = {
                    device = "auto";
                    warning_threshold = 20;
                    warning_color = "error";
                };
                media = {
                    scale = 0.75;
                    hide_when_no_media = true;
                    title_scroll = "on_hover";
                };
                privacy = {
                    hide_inactive = true;
                    active_color = "error";
                };
                recorder = {
                    type = "noctalia/screen_recorder:recorder";
                };
                color-picker = {
                    type = "oldirtty/color_picker:widget";
                };
                tray = {
                    drawer = true;
                };
                workspaces = {
                    capsule_radius = 4;
                    capsule_padding = 6;
                    empty_color = "on_surface";
                    focused_color = "hover";
                    hide_when_empty = true;
                    labels_only_when_occupied = true;
                    occupied_color = "on_surface";
                    style = "minimal";
                    scale = 1.2;
                };
            };
            plugins = {
                source = [
                    {
                        enabled = true;
                        auto_update = false;
                        kind = "git";
                        location = "https://github.com/noctalia-dev/official-plugins";
                        name = "official";
                    }

                    {
                        enabled = true;
                        auto_update = false;
                        kind = "git";
                        location = "https://github.com/noctalia-dev/community-plugins";
                        name = "community";
                    }
                ];
                enabled = [
                    "noctalia/bongocat"
                    "oldirtty/color_picker"
                    "whyoolw/sharednd"
                    "noctalia/screen_recorder"
                ];
            };
            plugin_settings = {
                "noctalia/screen_recorder" = {
                    directory = "~/docs/vids/recordings";
                    filename_pattern = "recording_%Y%m%d_%H%M%S";
                    hide_inactive = false;
                };
                "oldirtty/color_picker" = {
                    hyprpicker-lowercase = true;
                };
            };
            bar.default = {
                shadow = false;
                contact_shadow = true;
                capsule = true;
                concave_edge_corners = false;
                font_weight = 700;
                margin_ends = 0;
                radius = 0;
                capsule_padding = 6;
                start = [
                    "launcher"
                    "workspaces"
                ];
                center = [
                    "clock"
                    "privacy"
                ];
                end = [
                    "group:g4"
                    "group:g3"
                    "group:g2"
                    "group:g1"
                ];
                capsule_group = [
                    {
                        id = "g1";
                        members = [
                            "clipboard"
                            "color-picker"
                            "screenshot"
                            "recorder"
                            "control-center"
                        ];
                    }
                    {
                        id = "g2";
                        members = [
                            "network"
                            "bluetooth"
                            "volume"
                            "brightness"
                            "battery"
                        ];
                    }
                    {
                        id = "g3";
                        members = [
                            "notifications"
                            "tray"
                        ];
                    }
                    {
                        id = "g4";
                        members = [
                            "media"
                            "cat"
                        ];
                    }
                ];
            };
            lockscreen_widgets =
                let
                    kanshiOutputs = builtins.map (e: e.output) (
                        builtins.filter (e: e ? output) config.services.kanshi.settings
                    );

                    widgetTemplates = {
                        login-box = {
                            type = "login_box";
                            box_height = 70.0;
                            box_width = 400.0;
                            fx = 0.5;
                            fy = 608.0 / 864.0;
                            settings = {
                                background_color = "surface_variant";
                                background_opacity = 0.88;
                                background_radius = 12.0;
                                center_password_text = false;
                                input_opacity = 1.0;
                                input_radius = 6.0;
                                show_caps_lock = true;
                                show_keyboard_layout = true;
                                show_login_button = true;
                                show_password_hint = false;
                            };
                        };
                        clock-date = {
                            type = "clock";
                            box_height = 40.0;
                            box_width = 100.0;
                            fx = 0.5;
                            fy = 200.0 / 864.0;
                            settings = {
                                background = false;
                                clock_style = "digital";
                                format = "{:%a, %b %e}";
                                shadow = true;
                            };
                        };
                        clock-time = {
                            type = "clock";
                            box_height = 40.0;
                            box_width = 200.0;
                            fx = 0.5;
                            fy = 240.0 / 864.0;
                            rotation = 0.0;
                            settings = {
                                background = false;
                                clock_style = "digital";
                                format = "{:%H:%M}";
                                shadow = true;
                            };
                        };
                        media-player = {
                            type = "media_player";
                            box_height = 168.0;
                            box_width = 328.0;
                            fx = 0.5;
                            fy = 0.5;
                            rotation = 0.0;
                            settings = {
                                background = true;
                                color = "on_surface";
                                hide_when_no_media = true;
                                layout = "horizontal";
                                shadow = true;
                            };
                        };
                    };

                    mkWidgetsForOutput =
                        output:
                        let
                            criteria = output.criteria;
                            dims = lib.splitString "x" output.mode;
                            physWidth = lib.toInt (builtins.elemAt dims 0);
                            physHeight = lib.toInt (builtins.elemAt dims 1);
                            scale = output.scale or 1.0;
                            logicalWidth = physWidth / scale;
                            logicalHeight = physHeight / scale;
                        in
                        lib.mapAttrs' (
                            name: w:
                            let
                                widgetDef =
                                    removeAttrs w [
                                        "fx"
                                        "fy"
                                    ]
                                    // {
                                        output = criteria;
                                        cx = logicalWidth * w.fx;
                                        cy = logicalHeight * w.fy;
                                    };
                            in
                            lib.nameValuePair "${name}@${criteria}" widgetDef
                        ) widgetTemplates;

                    allWidgets = lib.foldl' (
                        acc: output: acc // (mkWidgetsForOutput output)
                    ) { } kanshiOutputs;
                in
                {
                    enabled = true;
                    grid = {
                        cell_size = 8;
                        major_interval = 4;
                        visible = true;
                    };
                    widget = allWidgets;
                };
        };
    };

    home.file."${config.programs.noctalia.settings.wallpaper.directory}" =
        lib.mkIf
            (
                config.programs.noctalia.enable
                && config.programs.noctalia.settings.wallpaper.enabled
            )
            {
                source = ../../../assets/wallpapers;
                recursive = true;
            };

    wayland.windowManager.mango.settings.exec-once =
        lib.mkIf
            (config.programs.noctalia.enable && config.wayland.windowManager.mango.enable)
            [
                "${config.programs.noctalia.package}/bin/noctalia"
            ];
}
