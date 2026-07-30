{
    pkgs,
    ...
}:
{
    programs.zathura = {
        enable = true;
        package = pkgs.zathura;
        options = {
            database = "sqlite";
            selection-clipboard = "clipboard";
            statusbar-h-padding = 0;
            statusbar-v-padding = 0;
            page-padding = 1;
            statusbar-home-tilde = true;
            window-title-basename = true;
        };
        mappings = {
            u = "scroll half-up";
            d = "scroll half-down";
            D = "toggle_page_mode";
            r = "reload";
            R = "rotate";
            K = "zoom in";
            J = "zoom out";
            i = "recolor";
            p = "print";
            g = "goto top";
            ";" = "snap_to_page";
            "=" = "zoom in";
            "-" = "zoom out";
            "+" = "zoom best-fit";
            "[presentation] k" = "scroll full-up";
            "[presentation] j" = "scroll full-down";
        };
    };
}
