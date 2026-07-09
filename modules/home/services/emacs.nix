{ pkgs, config, ... }:
{
    services.emacs = {
        enable = config.programs.emacs.enable;
        package =
            if config.programs.emacs.enable then
                config.programs.emacs.finalPackage
            else
                pkgs.emacs;
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
}
