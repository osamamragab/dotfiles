{
    flake.aspects.virtualisation = {
        nixos = { pkgs, ... }: {
            virtualisation.docker = {
                enable = true;
                package = pkgs.docker;
                rootless = {
                    enable = true;
                    setSocketVariable = true;
                };
            };
        };
    };
}
