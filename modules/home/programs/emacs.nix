{
    pkgs,
    lib,
    config,
    ...
}:
let
    configPath = ../files/emacs;
in
{
    programs.emacs = {
        enable = true;
        package = pkgs.emacs-pgtk;
    };
    home.file.".config/emacs" =
        lib.mkIf (config.programs.emacs.enable && builtins.pathExists configPath)
            {
                source = configPath;
                recursive = true;
            };
    home.shellAliases = lib.mkIf config.programs.emacs.enable {
        emacs = "emacsclient -nca emacs";
    };
}
