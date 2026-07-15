{ pkgs, ... }:
{
    services.gnome-keyring = {
        enable = true;
        package = pkgs.gnome-keyring;
        components = [ ];
    };
}
