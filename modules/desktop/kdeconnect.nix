{
    flake.aspects.desktop = {
        nixos = {
            networking = {
                firewall =
                    let
                        portRange = {
                            from = 1714;
                            to = 1764;
                        };
                    in
                    {
                        allowedTCPPortRanges = [ portRange ];
                        allowedUDPPortRanges = [ portRange ];
                    };
            };
        };

        homeManager = { pkgs, ... }: {
            services.kdeconnect = {
                enable = true;
                package = pkgs.kdePackages.kdeconnect-kde;
                indicator = true;
            };
        };
    };
}
