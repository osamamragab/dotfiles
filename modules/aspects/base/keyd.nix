{
  flake.aspects.base = {
    nixos = {
      pkgs,
      lib,
      config,
      host,
      ...
    }: let
      cfg = config.services.keyd;
      iniFormat = pkgs.formats.ini {};
      mkSettings = settings:
        settings |> lib.recursiveUpdate (cfg.keyboards.default.settings or {});
    in {
      services.keyd = {
        enable = true;
        package = pkgs.keyd;
        keyboards = {
          default = {
            ids = ["*"];
            settings = {
              main = {
                capslock = "overload(control, esc)";
              };
            };
          };
          redragon-k613 = {
            ids = ["258a:002a"];
            settings = mkSettings {
              main = {
                esc = "`";
              };
            };
          };
        };
      };

      systemd.services.keyd.serviceConfig.CapabilityBoundingSet = lib.optional cfg.enable "CAP_SETGID";

      users.groups.keyd.members = lib.optional cfg.enable host.user;
      users.groups.input.members = lib.optional cfg.enable host.user;

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

    homeManager = {
      pkgs,
      lib,
      osConfig ? {},
      ...
    }: let
      cfg = osConfig.services.keyd or {enable = false;};
      iniFormat = pkgs.formats.ini {};
    in {
      home.packages = lib.optional cfg.enable pkgs.keyd;

      xdg.configFile."keyd/app.conf".source = lib.mkIf cfg.enable (
        iniFormat.generate "app.conf" (
          lib.genAttrs [
            "firefox"
            "org-mozilla-firefox"
            "chromium"
            "org-chromium-chromium"
          ]
          (_: {
            "control.y" = "C-c";
            "control.p" = "C-v";
          })
        )
      );
    };
  };
}
