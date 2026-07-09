{ pkgs, lib, config, ... }:
{
    programs.parallel = {
        enable = true;
        package = pkgs.parallel;
        will-cite = false; # disabled because it creates ~/.parallel by default
    };

    home.sessionVariables.PARALLEL_HOME = lib.mkIf config.programs.parallel.enable "${config.xdg.dataHome}/parallel";
    home.file."${config.home.sessionVariables.PARALLEL_HOME}/will-cite" = lib.mkIf config.programs.parallel.enable {
        text = "";
    };
}
