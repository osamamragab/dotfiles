{ pkgs, lib, config, ... }:
{
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
    };
}
