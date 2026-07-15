{
    config,
    custom,
    ...
}:
{
    imports = custom.utils.importDirs [
        ./config
        ./programs
        ./services
        ./extras
    ];

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
