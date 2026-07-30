{
    pkgs,
    lib,
    config,
    ...
}:
{
    programs.foot = {
        enable = true;
        package = pkgs.foot;
        server = {
            enable = true;
            systemdTarget = config.wayland.systemd.target;
        };
        settings = {
            main = {
                dpi-aware = "no";
            };
            key-bindings = {
                unicode-input = "none";
                spawn-terminal = "Control+Shift+Return";
                clipboard-copy = "Control+Shift+y";
                clipboard-paste = "Control+Shift+p";
                scrollback-up-line = "Control+Shift+k";
                scrollback-down-line = "Control+Shift+j";
                scrollback-up-half-page = "Control+Shift+u";
                scrollback-down-half-page = "Control+Shift+d";
                show-urls-launch = "Control+Shift+o";
                show-urls-copy = "Control+Shift+i";
                pipe-command-output = "[wl-copy] Control+Shift+c";
            };
            search-bindings = {
                clipboard-paste = "Control+Shift+p";
                scrollback-up-line = "Control+Shift+k";
                scrollback-down-line = "Control+Shift+j";
                scrollback-up-half-page = "Control+Shift+u";
                scrollback-down-half-page = "Control+Shift+d";
            };
            cursor = {
                style = "block";
                unfocused-style = "hollow";
                blink = "no";
                blink-rate = 0;
            };
        };
    };

    home.sessionVariables = lib.mkIf config.programs.foot.enable {
        TERMINAL =
            if config.programs.foot.server.enable then
                "${config.programs.foot.package}/bin/footclient"
            else
                "${config.programs.foot.package}/bin/foot";
    };

    xdg.terminal-exec.settings.default =
        lib.mkIf (config.programs.foot.enable && config.xdg.terminal-exec.enable)
            (
                if config.programs.foot.server.enable then
                    [
                        "footclient.desktop"
                        "foot.desktop"
                    ]
                else
                    [ "foot.desktop" ]
            );
}
