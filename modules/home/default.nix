{ lib, config, ... }:
let
    importDir = dir:
        lib.filter
        (path: lib.hasSuffix ".nix" (toString path))
        (lib.filesystem.listFilesRecursive dir);
in
{
    imports =
        importDir ./config
        ++ importDir ./programs
        ++ importDir ./services
        ++ importDir ./extras;

    programs.home-manager.enable = true;
    home = {
        preferXdgDirectories = config.xdg.enable;
        enableNixpkgsReleaseCheck = true;
        file = {
            ".local/bin" = {
                source = ./files/bin;
                recursive = true;
            };
            ".local/share/menus" = {
                source = ./files/menus;
                recursive = true;
            };
        };
    };
}
