{
  flake.aspects.desktop = {
    homeManager =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      let
        cfg = config.programs.foot;
      in
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

        home.sessionVariables = lib.mkIf cfg.enable {
          TERMINAL =
            if cfg.server.enable then
              "${cfg.package}/bin/footclient"
            else
              "${cfg.package}/bin/foot";
        };

        xdg.terminal-exec.settings.default = lib.mkIf cfg.enable (
          if cfg.server.enable then
            [
              "footclient.desktop"
              "foot.desktop"
            ]
          else
            [ "foot.desktop" ]
        );
      };
  };
}
