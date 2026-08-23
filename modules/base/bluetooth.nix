{
    flake.aspects.base = {
        nixos = { pkgs, ... }: {
            hardware.bluetooth = {
                enable = true;
                package = pkgs.bluez;
                powerOnBoot = true;
                settings = {
                    General = {
                        ControllerMode = "bredr";
                        Experimental = true;
                        FastConnectable = true;
                        ClassicBondedOnly = true;
                    };
                    Policy = {
                        AutoEnable = true;
                    };
                };
            };
        };

        homeManager = { pkgs, ... }: {
            services.mpris-proxy = {
                enable = true;
                package = pkgs.bluez;
            };
        };
    };
}
