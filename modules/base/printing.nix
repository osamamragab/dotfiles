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
                services.printing = {
                    enable = true;
                    package = pkgs.cups;
                    drivers = with pkgs; [
                        gutenprint
                        hplip
                        splix
                    ];
                };

                users.groups.lp.members = [ host.user ];
                users.groups.lpadmin.members = config.users.groups.lp.members;
            };
    };
}
