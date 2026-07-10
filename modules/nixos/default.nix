{ pkgs, ... }:
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

    nix = {
        package = pkgs.nixVersions.latest;
        checkConfig = true;
        gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 7d";
        };
        settings = {
            trusted-users = [ "@wheel" ];
            experimental-features = [
                "nix-command"
                "flakes"
            ];
            use-xdg-base-directories = true;
            cores = 0; # use all cores
            max-jobs = "auto";
            http-connections = 25;
            auto-optimise-store = true;
        };
    };
}
