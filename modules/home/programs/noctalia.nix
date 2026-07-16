{
    inputs,
    pkgs,
    lib,
    config,
    custom,
    ...
}:
{
    imports = [
        inputs.noctalia.homeModules.default
    ];

    home.packages = with pkgs; [
        gpu-screen-recorder # required for noctalia/screen_recorder plugin.
    ];

    programs.noctalia = {
        enable = true;
        settings = {
            audio.enable_overdrive = true;
            desktop_widgets.enabled = false;
            theme = {
                mode = "dark";
                source = "builtin";
                builtin = "Nord";
                wallpaper_scheme = "soft";
            };
            dock = {
                enabled = true;
                shadow = false;
                reserve_space = false;
                show_dots = true;
                smart_auto_hide = true;
                launcher_position = "end";
            };
            shell = {
                font_family = "monospace";
                date_format = "%A, %F";
                launcher.providers.calculator.prefix = "=";
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
            };
            osd = {
                position_vertical = "top_right";
            };
            wallpaper = {
                enabled = true;
                fill_mode = "stretch";
                fill_color = "#2e3440";
                directory = "${config.xdg.userDirs.pictures}/wallpapers";
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
                session.enabled = false;
                clipboard.enabled = false;
                wallpaper.enabled = false;
                brightness.enabled = false;
                notifications.enabled = true;
                bluetooth = {
                    enabled = true;
                    show_label = true;
                };
                cat = {
                    enabled = true;
                    type = "noctalia/bongocat:cat";
                    tappy_mode = true;
                    audio_spectrum = true;
                    use_mpris_filter = true;
                };
                clock = {
                    enabled = true;
                    capsule_radius = 4;
                    capsule_padding = 10;
                    format = "{:%a %H:%M}";
                    timezone = custom.systemInfo.timeZone;
                    tooltip_format = "{:%d %b (W%U)}";
                };
                battery = {
                    enabled = true;
                    device = "auto";
                    warning_threshold = 20;
                    warning_color = "error";
                };
                media = {
                    enabled = true;
                    scale = 0.9;
                    hide_when_no_media = true;
                    title_scroll = "on_hover";
                };
                privacy = {
                    enabled = true;
                    hide_inactive = true;
                    active_color = "error";
                };
                recorder = {
                    enabled = true;
                    type = "noctalia/screen_recorder:recorder";
                };
                tray = {
                    enabled = true;
                    drawer = true;
                };
                workspaces = {
                    enabled = true;
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
                    "recorder"
                ];
                end = [
                    "group:g4"
                    "group:g3"
                    "group:g2"
                    "group:g1"
                ];
                capsule_group = [
                    {
                        enabled = true;
                        id = "g1";
                        members = [
                            "control-center"
                            "session"
                        ];
                    }
                    {
                        enabled = true;
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
                        enabled = true;
                        id = "g3";
                        members = [
                            "notifications"
                            "tray"
                        ];
                    }
                    {
                        enabled = true;
                        id = "g4";
                        members = [
                            "media"
                            "cat"
                        ];
                    }
                ];
            };
        };
    };

    home.file."${config.programs.noctalia.settings.wallpaper.directory}/wallpapers" =
        lib.mkIf config.programs.noctalia.settings.wallpaper.enabled {
            source = ../../../assets/wallpapers;
            recursive = true;
        };

    wayland.windowManager.mango.settings.exec-once =
        lib.mkIf config.wayland.windowManager.mango.enable
            [
                "${config.programs.noctalia.package}/bin/noctalia"
            ];
}
