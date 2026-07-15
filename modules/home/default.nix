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
        username = custom.systemInfo.user;
        homeDirectory = "/home/${custom.systemInfo.user}";
        stateVersion = custom.systemInfo.stateVersion;
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
