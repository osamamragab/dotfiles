{ pkgs, config, ... }:
{
    services.wl-clip-persist = {
        enable = true;
        package = pkgs.wl-clip-persist;
        clipboardType = "regular";
        extraOptions = [
            "--reconnect-tries"
            "0"
        ];
        systemdTargets = [
            config.wayland.systemd.target
        ];
    };
}
