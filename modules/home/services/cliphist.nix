{ pkgs, config, ... }:
{
    services.cliphist = {
        enable = true;
        package = pkgs.cliphist;
        allowImages = true;
        clipboardPackage = pkgs.wl-clipboard;
        systemdTargets = [
            config.wayland.systemd.target
        ];
    };
}
