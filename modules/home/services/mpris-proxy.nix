{ pkgs, ... }:
{
    services.mpris-proxy = {
        enable = true;
        package = pkgs.bluez;
    };
}
