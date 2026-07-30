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
        tmux = {
            enableShellIntegration = config.programs.tmux.enable;
            shellIntegrationOptions = [
                "-d 40%"
            ];
        };
    };
}
