{
    pkgs,
    lib,
    config,
    ...
}:
{
    programs.satty = {
        enable = true;
        package = pkgs.satty;
        settings = {
            general = {
                fullscreen = true;
                early-exit = true;
                copy-command = "wl-copy --type image/png";
            };
            keybinds = {
                pointer = "p";
                crop = "c";
                brush = "b";
                line = "l";
                arrow = "a";
                rectangle = "r";
                ellipse = "e";
                text = "t";
                marker = "m";
                blur = "u";
                highlight = "h";
            };
            color-palette.palette = lib.unique config.lib.stylix.colors.withHashtag.toList;
        };
    };
}
