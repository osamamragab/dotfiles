{
    flake.aspects.desktop = {
        nixos = { pkgs, ... }: {
            services.udisks2 = {
                enable = true;
                package = pkgs.udisks;
            };
        };

        homeManager = { pkgs, ... }: {
            services.udiskie = {
                enable = true;
                package = pkgs.udiskie;
                settings = {
                    program_options = {
                        tray = "auto";
                        notify = true;
                        terminal = "${pkgs.xdg-terminal-exec}/bin/xdg-terminal-exec";
                        file_manager = "${pkgs.xdg-utils}/bin/xdg-open";
                    };
                };
            };
        };
    };
}
