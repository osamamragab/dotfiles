{
    pkgs,
    config,
    ...
}:
{
    home.packages = [ pkgs.gcr ];
    services.gpg-agent = {
        enable = true;
        enableZshIntegration = config.programs.zsh.enable;
        enableBashIntegration = config.programs.bash.enable;
        enableFishIntegration = config.programs.fish.enable;
        enableNushellIntegration = config.programs.nushell.enable;
        enableSshSupport = true;
        grabKeyboardAndMouse = true;
        maxCacheTtl = 1800;
        defaultCacheTtl = 600;
        pinentry = {
            package = pkgs.pinentry-gnome3;
            program = "pinentry-gnome3";
        };
    };
}
