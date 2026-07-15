{
    pkgs,
    lib,
    config,
    ...
}:
{
    security.apparmor = {
        enable = true;
        killUnconfinedConfinables = true;
    };

    security.audit = {
        enable = true;
        package = pkgs.audit;
    };

    security.auditd = {
        enable = true;
        package = config.security.audit.package or pkgs.audit;
    };

    security.rtkit = {
        enable = true;
        package = pkgs.rtkit;
    };

    services.pipewire = {
        enable = true;
        package = pkgs.pipewire;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };

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
        };
    };
    environment.etc."libinput/local-overrides.conf" = lib.mkIf config.services.keyd.enable {
        text = ''
            [Serial Keyboards]
            MatchUdevType=keyboard
            MatchName=keyd virtual keyboard
            AttrKeyboardIntegration=internal
        '';
    };
}
