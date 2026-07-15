{
    pkgs,
    config,
    ...
}:
{
    programs.direnv = {
        enable = true;
        package = pkgs.direnv;
        enableBashIntegration = config.programs.bash.enable;
        enableZshIntegration = config.programs.zsh.enable;
        enableFishIntegration = config.programs.fish.enable;
        enableNushellIntegration = config.programs.nushell.enable;
        silent = false;
        nix-direnv = {
            enable = true;
            package = pkgs.nix-direnv;
        };
        mise = {
            enable = config.programs.mise.enable;
            package = pkgs.mise;
        };
    };
}
