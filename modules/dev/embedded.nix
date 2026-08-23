{
    flake.aspects.dev = {
        nixos =
            {
                pkgs,
                lib,
                config,
                host,
                ...
            }:
            {
                hardware.i2c = {
                    enable = true;
                    group = "i2c";
                };

                users.groups.i2c.members = [ host.user ];
            };
    };
}
