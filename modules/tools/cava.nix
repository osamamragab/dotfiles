{
    flake.aspects.tools = {
        homeManager = { pkgs, config, ... }: {
            programs.cava = {
                enable = true;
                package = pkgs.cava;
                settings = {
                    general.framerate = 60;
                    smoothing.noise_reduction = 88;
                    color =
                        let
                            colors = config.lib.stylix.colors.withHashtag;
                        in
                        {
                            gradient = 1;
                            gradient_count = 3;
                            gradient_color_1 = "'${colors.base04}'";
                            gradient_color_2 = "'${colors.base12}'";
                            gradient_color_3 = "'${colors.base07}'";
                        };
                };
            };
        };
    };
}
