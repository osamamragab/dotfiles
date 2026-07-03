{ pkgs, ... }:
{
    imports = [
        ./boot.nix
        ./locale.nix
        ./packages.nix
        ./services/keyd.nix
        ./services/pipewire.nix
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    environment = {
        localBinInPath = true;
        pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];
        systemPackages = with pkgs; [
            git
        ];
    };

    networking.networkmanager.enable = true;
}
