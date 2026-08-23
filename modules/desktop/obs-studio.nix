{
    flake.aspects.desktop = {
        homeManager = { pkgs, ... }: {
            programs.obs-studio = {
                enable = true;
                package = pkgs.obs-studio;
            };
        };
    };
}
