{ pkgs, config, ... }:
{
    nix = {
        checkConfig = true;
        useXdg = config.xdg.enable;
        gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 7d";
        };
        settings = {
            experimental-features = [ "nix-command" "flakes" ];
        };
    };
}
