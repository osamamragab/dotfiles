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
        cfg = config.services.kanshi;
        nextTo =
          criteria:
          let
            output =
              cfg.settings
              |> lib.map (e: e.output or null)
              |> lib.findFirst (e: (e.criteria or null) == criteria) null;
            scale = output.scale or 1.0;
            dims = output.mode or "0x0" |> lib.splitString "x";
            pos = output.position or "0,0" |> lib.splitString ",";
            posX = lib.elemAt pos 0 |> lib.toInt;
            width = lib.elemAt dims 0 |> lib.toInt;
            scaledWidth = lib.floor (width / scale);
            x = lib.toString (posX + scaledWidth);
            y = lib.elemAt pos 1;
          in
          "${x},${y}";
      in
      {
        services.kanshi = {
          enable = true;
          package = pkgs.kanshi;
          systemdTarget = config.wayland.systemd.target;
          settings = [
            {
              output = {
                criteria = "eDP-1";
                mode = "1920x1080";
                position = "0,0";
                scale = 1.25;
              };
            }
            {
              output = {
                criteria = "HDMI-A-1";
                mode = "1920x1200";
                position = nextTo "eDP-1";
                scale = 1.0;
              };
            }
            {
              output = {
                criteria = "DP-2";
                mode = "1680x1050";
                position = nextTo "HDMI-A-1";
                scale = 1.0;
              };
            }
            {
              output = {
                criteria = "LVDS-1";
                mode = "1366x768";
                position = "0,0";
                scale = 1.0;
              };
            }
            {
              profile = {
                name = "laptop";
                outputs = [
                  {
                    criteria = "eDP-1";
                    status = "enable";
                  }
                ];
              };
            }
            {
              profile = {
                name = "monitor";
                outputs = [
                  {
                    criteria = "eDP-1";
                    status = "enable";
                  }
                  {
                    criteria = "HDMI-A-1";
                    status = "enable";
                  }
                ];
              };
            }
            {
              profile = {
                name = "monitor-only";
                outputs = [
                  {
                    criteria = "eDP-1";
                    status = "disable";
                  }
                  {
                    criteria = "HDMI-A-1";
                    status = "enable";
                  }
                ];
              };
            }
            {
              profile = {
                name = "dock";
                outputs = [
                  {
                    criteria = "eDP-1";
                    status = "enable";
                  }
                  {
                    criteria = "HDMI-A-1";
                    status = "enable";
                  }
                  {
                    criteria = "DP-2";
                    status = "enable";
                  }
                ];
              };
            }
            {
              profile = {
                name = "dock-only";
                outputs = [
                  {
                    criteria = "eDP-1";
                    status = "disable";
                  }
                  {
                    criteria = "HDMI-A-1";
                    status = "enable";
                  }
                  {
                    criteria = "DP-2";
                    status = "enable";
                  }
                ];
              };
            }
          ];
        };
      };
  };
}
