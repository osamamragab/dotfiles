{ pkgs, ... }:
{
    gtk = {
        enable = true;
        gtk2.enable = true;
        gtk3.enable = true;
        gtk4.enable = true;
        colorScheme = "dark";
        font = {
            package = null;
            name = "Sans";
            size = 11;
        };
        theme = {
            package = pkgs.nordic;
            name = "Nordic";
        };
        iconTheme = {
            package = pkgs.nordzy-icon-theme;
            name = "Nordzy";
        };
        cursorTheme = {
            package = pkgs.nordzy-cursor-theme;
            name = "Nordzy";
            size = 24;
        };
    };
}
