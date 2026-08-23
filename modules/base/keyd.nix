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
                mkSettings =
                    settings:
                    settings
                    |> lib.recursiveUpdate (config.services.keyd.keyboards.default.settings or { });
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

                environment.etc."libinput/local-overrides.quirks" =
                    lib.mkIf config.services.keyd.enable
                        {
                            source =
                                let
                                    iniFormat = pkgs.formats.ini { };
                                in
                                iniFormat.generate "libinput-local-overrides.quirks" {

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
                ...
            }:
            {
                home.packages = [ pkgs.keyd ];

                xdg.configFile."keyd/app.conf".source =
                    let
                        iniFormat = pkgs.formats.ini { };
                        common = {
                            "control.y" = "C-c";
                            "control.p" = "C-v";
                        };
                    in
                    iniFormat.generate "app.conf" {
                        firefox = common;
                        org-mozilla-firefox = common;
                        chromium = common;
                        org-chromium-chromium = common;
                    };

                wayland.windowManager.mango.settings.exec-once =
                    lib.mkIf config.wayland.windowManager.mango.enable
                        [
                            "${pkgs.keyd}/bin/keyd-application-mapper"
                        ];

            };
    };
}
