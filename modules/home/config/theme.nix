{
    inputs,
    pkgs,
    lib,
    config,
    ...
}:
{
    imports = [
        inputs.stylix.homeModules.default
    ];

    home.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
    ];

    home.pointerCursor.enable = true;
    gtk.enable = true;
    qt.enable = true;

    stylix = {
        enable = true;
        autoEnable = true;
        overlays.enable = false;
        polarity = "dark";
        base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
        image = ../../../assets/wallpaper.png;
        imageScalingMode = "stretch";
        fonts = {
            serif = {
                package = pkgs.dejavu_fonts;
                name = "DejaVu Serif";
            };
            sansSerif = {
                package = pkgs.dejavu_fonts;
                name = "DejaVu Sans";
            };
            monospace = {
                package = pkgs.nerd-fonts.hack;
                name = "Hack Nerd Font";
            };
            emoji = {
                package = pkgs.noto-fonts-color-emoji;
                name = "Noto Color Emoji";
            };
        };
        icons = {
            enable = true;
            package = pkgs.nordzy-icon-theme;
            dark = "Nordzy-dark";
            light = "Nordzy";
        };
        cursor = {
            package = pkgs.nordzy-cursor-theme;
            name = "Nordzy-cursors";
            size = 24;
        };
        opacity = {
            popups = 0.95;
            terminal = 0.95;
            applications = 1.0;
        };
    };

    fonts.fontconfig = {
        enable = true;
        configFile = {
            css-aliases = {
                enable = true;
                priority = 90;
                settings = {
                    description = "Set CSS font aliases";
                    alias = [
                        {
                            family = "ui-monospace";
                            default.family = "monospace";
                        }
                        {
                            family = "system-ui";
                            default.family = "sans-serif";
                        }
                        {
                            family = "-apple-system";
                            default.family = "sans-serif";
                        }
                        {
                            family = "BlinkMacSystemFont";
                            default.family = "sans-serif";
                        }
                    ];
                };
            };
            noto-arabic = {
                enable = true;
                priority = 90;
                settings = {
                    description = "Set Noto font for Arabic";
                    match = [
                        {
                            "@target" = "pattern";
                            test = [
                                {
                                    "@name" = "lang";
                                    string = "ar";
                                }
                                {
                                    "@name" = "family";
                                    string = "sans-serif";
                                }
                            ];
                            edit = {
                                "@name" = "family";
                                "@mode" = "prepend";
                                string = "Noto Kufi Arabic";
                            };
                        }
                        {
                            "@target" = "pattern";
                            test = [
                                {
                                    "@name" = "lang";
                                    string = "ar";
                                }
                                {
                                    "@name" = "family";
                                    string = "serif";
                                }
                            ];
                            edit = {
                                "@name" = "family";
                                "@mode" = "prepend";
                                string = "Noto Naskh Arabic";
                            };
                        }
                    ];
                };
            };
        };
    };
}
