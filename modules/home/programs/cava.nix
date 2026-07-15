{
    pkgs,
    ...
}:
{
    programs.cava = {
        enable = true;
        package = pkgs.cava;
        settings = {
            general.framerate = 60;
            smoothing.noise_reduction = 88;
            color = {
                gradient = 1;
                gradient_count = 3;
                gradient_color_1 = "'#5e81ac'";
                gradient_color_2 = "'#81a1c1'";
                gradient_color_3 = "'#eceff4'";
            };
        };
    };
}
