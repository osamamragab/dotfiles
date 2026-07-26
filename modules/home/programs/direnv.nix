{
    pkgs,
    config,
    ...
}:
{
    programs.direnv = {
        enable = true;
        package = pkgs.direnv;
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
