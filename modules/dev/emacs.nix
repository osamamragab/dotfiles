{
    flake.aspects.dev = {
        homeManager =
            {
                pkgs,
                lib,
                config,
                ...
            }:
            {
                programs.emacs = {
                    enable = true;
                    package = pkgs.emacs-pgtk;
                };

                services.emacs = {
                    enable = config.programs.emacs.enable;
                    package = config.programs.emacs.finalPackage;
                    client = {
                        enable = true;
                        arguments = [
                            "-n"
                            "-c"
                            "-a"
                            "emacs"
                        ];
                    };
                    socketActivation.enable = false;
                    startWithUserSession = !config.services.emacs.socketActivation.enable;
                };

                home.file.".config/emacs" = lib.mkIf config.programs.emacs.enable {
                    source = ./emacs;
                    recursive = true;
                };

                home.shellAliases = lib.mkIf config.programs.emacs.enable {
                    emacs = "emacsclient -nca emacs";
                };
            };
    };
}
