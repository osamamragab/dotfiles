{
    pkgs,
    config,
    ...
}:
{
    programs.bash = {
        enable = true;
        package = pkgs.bashInteractive;
        enableCompletion = true;
        enableVteIntegration = true;
        historyFile = "${config.xdg.stateHome}/history";
        historyFileSize = 32768;
        historySize = 10000; # in-memory
        historyControl = [
            "ignoredups"
            "ignorespace"
        ];
        shellOptions = [
            "histappend"
            "extglob"
            "globstar"
            "checkjobs"
        ];
    };
}
