{
  flake.aspects.base = {
    nixos =
      {
        pkgs,
        lib,
        config,
        host,
        ...
      }:
      let
        cfg = config.services.keyd;
        iniFormat = pkgs.formats.ini { };
        mkSettings =
          settings:
          settings |> lib.recursiveUpdate (cfg.keyboards.default.settings or { });
        mkMainSettings = settings: mkSettings { main = settings; };
      in
      {
        services.keyd = {
          enable = true;
          package = pkgs.keyd;
          keyboards = {
            default = {
              ids = [ "*" ];
              settings = {
                main = {
                  capslock = "overload(control, esc)";
                };
              };
            };
            redragon-k613 = {
              ids = [ "258a:002a" ];
              settings = mkMainSettings {
                esc = "`";
              };
            };
          };
        };

        systemd.services.keyd.serviceConfig.CapabilityBoundingSet = [ "CAP_SETGID" ];

        users.groups.keyd.members = [ host.user ];

        environment.etc."libinput/local-overrides.quirks" = lib.mkIf cfg.enable {
          source = iniFormat.generate "libinput-local-overrides.quirks" {
            "Serial Keyboards" = {
              MatchUdevType = "keyboard";
              MatchName = "keyd virtual keyboard";
              AttrKeyboardIntegration = "internal";
            };
          };
        };
      };

    homeManager =
      {
        pkgs,
        lib,
        config,
        osConfig ? null,
        ...
      }:
      let
        cfg = osConfig.services.keyd or null;
        iniFormat = pkgs.formats.ini { };
        common = {
          "control.y" = "C-c";
          "control.p" = "C-v";
        };
      in
      {
        home.packages = [ pkgs.keyd ];

        xdg.configFile."keyd/app.conf".source = iniFormat.generate "app.conf" {
          firefox = common;
          org-mozilla-firefox = common;
          chromium = common;
          org-chromium-chromium = common;
        };

        wayland.windowManager =
          lib.optionalAttrs
            ((cfg.enable or false) && (config.wayland.windowManager ? mango))
            {
              mango.settings.exec-once = [
                "${pkgs.keyd}/bin/keyd-application-mapper"
              ];
            };
      };
  };
}
