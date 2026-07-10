{ pkgs, ... }:
{
    virtualisation ={
        docker = {
            enable = false;
            package = pkgs.docker;
            rootless = {
                enable = true;
                setSocketVariable = true;
            };
        };
        podman = {
            enable = true;
            package = pkgs.podman;
        };
    };
}
