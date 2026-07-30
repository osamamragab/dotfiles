{
    pkgs,
    ...
}:
{
    programs.btop = {
        enable = true;
        package = pkgs.btop;
        settings = {
            vim_keys = true;
            truecolor = true;
            force_tty = false;
            update_ms = 2000;
            terminal_sync = true;
            rounded_corners = true;
            theme_background = false;
        };
    };
}
