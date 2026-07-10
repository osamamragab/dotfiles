{
    lib,
    pkgs,
    config,
    ...
}:
{
    programs.fzf = {
        enable = true;
        package = pkgs.fzf;
        enableZshIntegration = config.programs.zsh.enable;
        enableBashIntegration = config.programs.bash.enable;
        enableFishIntegration = config.programs.fish.enable;
        enableNushellIntegration = config.programs.nushell.enable;
        defaultCommand = lib.mkIf config.programs.fd.enable "fd --type f --type symlink --hidden --strip-cwd-prefix";
        defaultOptions = [
            "--tiebreak=begin"
            "--layout reverse"
            "--height=~40%"
            "--ansi"
            "--gutter-raw=' '"
            "--highlight-line"
            "--bind=ctrl-y:accept"
        ];
        fileWidget.command = config.programs.fzf.defaultCommand;
        changeDirWidget.command = lib.mkIf config.programs.fd.enable "fd --type d --hidden --strip-cwd-prefix";
        historyWidget.options = [
            "--sort"
            "--exact"
        ];
        colors = {
            fg = "7";
            hl = "3";
            "fg+" = "15";
            "bg+" = "8";
            "hl+" = "4";
            marker = "10";
            pointer = "0";
            gutter = "0";
            info = "8";
            prompt = "8";
            border = "8";
            spinner = "8";
            header = "8";
            footer = "8";
        };
        tmux = {
            enableShellIntegration = config.programs.tmux.enable;
            shellIntegrationOptions = [
                "-d 40%"
            ];
        };
    };
}
