{ pkgs, lib, config, ... }:
{
    programs.emacs = {
        enable = true;
        package = pkgs.emacs-pgtk;
    };
    home.file.".config/emacs" = lib.mkIf config.programs.emacs.enable {
        source = ../files/emacs;
        recursive = true;
    };
}
