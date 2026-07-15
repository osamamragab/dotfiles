{
    pkgs,
    ...
}:
{
    home.packages = with pkgs; [
        nerd-fonts.hack
        # nerd-fonts.symbols-only
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
        dejavu_fonts
        # inter
        # ibm-plex
        # nerd-fonts.blex-mono
        # nerd-fonts.dejavu-sans-mono
    ];

    fonts.fontconfig = {
        enable = true;
        defaultFonts = {
            serif = [
                "Noto Serif"
                "DejaVu Serif"
            ];
            sansSerif = [
                "Noto Sans"
                "DejaVu Sans"
            ];
            monospace = [
                "Hack Nerd Font"
                "Noto Sans Mono"
                "DejaVu Sans Mono"
            ];
            emoji = [
                "Noto Color Emoji"
            ];
        };
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
