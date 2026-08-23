{
    flake.aspects.shell = {
        homeManager = { pkgs, config, ... }: {
            programs.bash = {
                enable = true;
                package = pkgs.bashInteractive;
                enableCompletion = true;
                enableVteIntegration = true;
                historyFile = "${config.xdg.stateHome}/history";
                historyFileSize = 32 * 1024;
                historySize = 10 * 1024; # in-memory
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
        };
    };
}
