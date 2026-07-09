{ ... }:
{
    imports = [
        ./boot.nix
        ./locale.nix
        ./packages.nix
        ./services.nix
        ./networking.nix
        ./documentation.nix
        ./virtualisation.nix
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
