{ pkgs, config, ... }:
{
    programs.waybar = {
        enable = true;
        package = pkgs.waybar;
        systemd = {
            enable = true;
            targets = [
                config.wayland.systemd.target
            ];
        };
        settings = {
            bar = {
                layer = "top";
                position = "top";
                height = 26;
                spacing = 0;
                modules-left = [
                    "ext/workspaces"
                ];
                modules-center = [
                    "clock"
                    "group/indicators"
                ];
                modules-right = [
                    "group/expander"
                    "mpris"
                    "wireplumber"
                    "bluetooth"
                    "network"
                    "battery"
                    "custom/days"
                ];
                "ext/workspaces" = {
                    format = "{icon}";
                    sort-by-id = true;
                    ignore-hidden = true;
                    on-click = "activate";
                    on-click-right = "deactivate";
                };
                clock = {
                    interval = 60;
                    format = "{:%a %H:%M}";
                    tooltip-format = "<span size='10pt'>{calendar}</span>";
                    calendar = {
                        mode = "month";
                        mode-mon-col = 3;
                        weeks-pos = "right";
                        on-scroll = 1;
                        format = {
                            months = "<span color='#eceff4'><b>{}</b></span>";
                            days = "<span color='#eceff4'><b>{}</b></span>";
                            weeks = "<span color='#8fbcbb'><b>W{}</b></span>";
                            weekdays = "<span color='#81a1c1'><b>{}</b></span>";
                            today = "<span color='#bf616a'><b>{}</b></span>";
                        };
                    };
                    actions = {
                        on-click = "shift_reset";
                        on-click-right = "mode";
                        on-scroll-up = "shift_up";
                        on-scroll-down = "shift_down";
                    };
                };
                wireplumber = {
                    format = "{icon}";
                    format-muted = "";
                    tooltip-format = "{volume}% - {node_name}";
                    on-click = "${config.xdg.binHome}/terminal -a terminal-floating wiremix";
                    on-click-right = "${pkgs.helvum}/bin/helvum";
                    on-click-middle = "${config.xdg.binHome}/audioctl output toggle";
                    max-volume = 200;
                    scroll-step = 5;
                    on-scroll-up = "${config.xdg.binHome}/audioctl output 5%+";
                    on-scroll-down = "${config.xdg.binHome}/audioctl output 5%-";
                    format-icons = {
                        headphone = "";
                        hands-free = "";
                        headset = "";
                        phone = "";
                        portable = "";
                        car = "";
                        default = ["" "" ""];
                    };
                };
                battery = {
                    interval = 5;
                    format = "{capacity}% {icon}";
                    format-discharging = "{icon}";
                    format-charging = "{icon}";
                    format-plugged = "";
                    format-icons = {
                        charging = ["󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅"];
                        default = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
                    };
                    format-full = "󰂅";
                    tooltip-format-discharging = "{power:>1.0f}W↓ {capacity}%";
                    tooltip-format-charging = "{power:>1.0f}W↑ {capacity}%";
                    on-click = "${config.xdg.binHome}/menu-handler power-profiles";
                    states = {
                        warning = 30;
                        critical = 15;
                    };
                };
                network = {
                    interval = 60;
                    format = "{ifname}";
                    format-wifi = "{icon}";
                    format-ethernet = "";
                    format-disconnected = "";
                    format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
                    on-click = "${config.xdg.binHome}/terminal -a terminal-floating nmtui";
                    tooltip-format = "{ifname} via {gwaddr}";
                    tooltip-format-wifi = "{essid} ({frequency}GHz) {signalStrength}% \n{ifname}: {ipaddr}/{cidr}";
                    tooltip-format-ethernet = "{ifname}: {ipaddr}/{cidr}";
                    tooltip-format-disconnected = "Disconnected";
                };
                bluetooth = {
                    format = "";
                    format-off = "󰂲";
                    format-disabled = "󰂲";
                    format-connected = "󰂱";
                    format-no-controller = "";
                    on-click = "${config.xdg.binHome}/terminal -a terminal-floating bluetui";
                    tooltip-format = "{controller_alias}\t{controller_address}";
                    tooltip-format-connected = "{controller_alias}\t{controller_address}\n{device_enumerate}";
                    tooltip-format-enumerate-connected = "- {device_alias}\t[{device_address}]";
                    tooltip-format-enumerate-connected-battery = "- {device_alias}\t[{device_address}]\t({device_battery_percentage}%)";
                };
                "group/expander" = {
                    orientation = "inherit";
                    drawer = {
                        transition-duration = 500;
                        children-class = "expander-group-item";
                    };
                    "custom/expand-icon" = {
                        format = "";
                        tooltip = false;
                        on-scroll-up = "";
                        on-scroll-down = "";
                        on-scroll-left = "";
                        on-scroll-right = "";
                    };
                    tray = {
                        icon-size = 16;
                        spacing = 8;
                    };
                };
                mpris = {
                    player = "playerctld";
                    format = "{status_icon}";
                    tooltip-format = "{title} • {artist}";
                    title-len = 10;
                    artist-len = 10;
                    status-icons = {
                        paused = "";
                        stopped = "";
                        playing = "";
                    };
                };
                privacy = {
                    icon-size = 14;
                    icon-spacing = 0;
                    transition-duration = 250;
                    ignore-monitor = true;
                    ignore = [
                        {
                            type = "audio-in";
                            name = "echo-cancel-capture";
                        }
                    ];
                    modules = [
                        {
                            type = "screenshare";
                            tooltip = true;
                            tooltip-icon-size = 24;
                        }
                        {
                            type = "audio-in";
                            tooltip = true;
                            tooltip-icon-size = 24;
                        }
                    ];
                };
                "custom/dnd" = {
                    format = "{}";
                    interval = "once";
                    on-click = "${pkgs.mako}/bin/makoctl mode -r dnd >/dev/null 2>&1";
                    tooltip = false;
                    signal = 7;
                    exec = pkgs.writeShellScript "dnd" ''
                        set -eu
                        makoctl mode 2>/dev/null | grep -Fxq dnd || exit 1
                        count="$(makoctl list 2>/dev/null | grep -c "^Notification")" || true
                        case "$count" in
                            0) count="" ;;
                            [1-9]) ;;
                            *) count="9+" ;;
                        esac
                        printf "%s\nDisable DnD" "$\{count:+ $count\}"
                        '';
                        };
                        "custom/recording" = {
                        format = "{}";
                        interval = "once";
                        on-click = "${config.xdg.binHome}/menu-handler screen-recording stop";
                        signal = 8;
                        exec = pkgs.writeShellScript "screen-recording" ''
                        set -eu
                        pgrep -x -u "$USER" wf-recorder >/dev/null 2>&1 &&
                        printf "\nStop recording\nactive"
                        '';
                        };
                        "custom/days" = {
                        format = "{}";
                        interval = 1800;
                        on-click = "${config.xdg.binHome}/terminal -a terminal-floating notes todo";
                        exec = pkgs.writeShellScript "days" ''
                            set -eu
                            # TODO: add birthdate to some variable.
                            dob="$(date -d "2004-06-09"  "+%s")"
                            now="$(date "+%s")"
                            days=$(( (now - dob) / 86400 ))
                            printf "%d\n" "$days"
                        '';
                };
            };
        };
        style = ''
            @define-color background #2e3440;
            @define-color foreground #eceff4;
            @define-color module #3b4252;
            @define-color active #5e81ac;
            @define-color urgent #b74e58;
            @define-color warning #e7c173;

            * {
                border: none;
                border-radius: 0;
                min-height: 10px;
                font-size: 12px;
                font-weight: bold;
                font-family: monospace;
                color: @foreground;
            }

            window#waybar {
                background-color: @background;
            }

            tooltip {
                padding: 2px;
                border-radius: 5px;
            }

            tooltip,
            .modules-right,
            .modules-center,
            #mode {
                background-color: @module;
            }

            .modules-right {
                border-bottom-left-radius: 5px;
            }
            .modules-right * {
                margin: 0 7.5px;
            }

            #indicators *,
            .modules-right * {
                min-width: 12px;
            }

            #mode,
            .modules-center {
                border-bottom-left-radius: 5px;
                border-bottom-right-radius: 5px;
            }

            .modules-center {
                padding: 0 10px;
            }

            #mode {
                padding: 5px 10px;
                margin-left: 10px;
            }

            #mode.normal,
            #custom-recording:not(.active) {
                opacity: 0;
            }

            #custom-dnd,
            #privacy-item,
            #custom-recording {
                margin-left: 10px;
                padding: 0 5px;
            }

            #tags > button,
            #workspaces > button {
                all: initial;
                padding: 0 6px;
                margin: 0 1.5px;
                min-width: 9px;
                background-color: @background;
            }
            #tags > button:not(.occupied),
            #workspaces > button.hidden {
                opacity: 0.5;
            }
            #tags > button.focused,
            #workspaces > button.active {
                opacity: 1;
                background-color: @module;
                box-shadow: inset 0 -5px @active;
            }

            #privacy-item,
            #custom-recording,
            #tags > button.urgent,
            #workspaces > button.urgent {
                box-shadow: inset 0 -5px @urgent;
            }
            menu {
                background-color: @background;
                border: 2px solid @active;
            }
            menu > separator {
                background-color: @module;
            }
            menu > menuitem {
                transition: background-color 150ms ease;
            }
            menu > menuitem:hover {
                background-color: @active;
            }
        '';
    };
}
