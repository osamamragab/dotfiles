{
    pkgs,
    ...
}:
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
            name = "Nordzy-cursors";
            size = 32;
        };
    };

    qt = {
        enable = true;
        platformTheme.name = "kvantum";
        style.name = "kvantum";
        kvantum = {
            enable = true;
            settings = {
                General = {
                    theme = "KvAdaptaDark";
                };
            };
        };
    };
}
