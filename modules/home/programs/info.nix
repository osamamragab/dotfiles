{ pkgs, lib, config, ... }:
{
    programs.info = {
        enable = true;
        package = pkgs.texinfoInteractive;
    };

    home.shellAliases = lib.mkIf config.programs.info.enable {
        info="info --vi-keys";
    };
}
