{ pkgs, lib, config, ... }:
let
    backgroundPath = ../files/background.png;
    backgroundExists = builtins.pathExists backgroundPath;
in
{
    home.packages = lib.mkIf backgroundExists [
        pkgs.wbg
    ];
    xdg.dataFile.bg= lib.mkIf backgroundExists {
        source = backgroundPath;
    };
    wayland.windowManager.mango.settings.exec-once =
        lib.mkIf (backgroundExists && config.wayland.windowManager.mango.enable)
        [
            "${pkgs.wbg}/bin/wbg --stretch $HOME/${config.xdg.dataFile.bg.target}"
        ];
}
