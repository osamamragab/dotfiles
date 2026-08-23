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
            {
                users = {
                    defaultUserShell = pkgs.bashInteractive;
                    users.${host.user} = {
                        name = host.user;
                        group = host.user;
                        isNormalUser = lib.mkDefault true;
                        useDefaultShell = lib.mkDefault true;
                        extraGroups = [ "wheel" ];
                    };
                    groups.${host.user} = { };
                };

                home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                };
            };

        homeManager = { host, ... }: {
            programs.home-manager.enable = true;
            home = {
                username = host.user;
                stateVersion = host.stateVersion;
                homeDirectory = "/home/${host.user}";
                enableNixpkgsReleaseCheck = true;
            };
        };
    };
}
