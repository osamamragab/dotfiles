{
    pkgs,
    lib,
    config,
    ...
}:
{
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
}
