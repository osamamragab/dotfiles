{ pkgs, ... }:
{
    services.podman = {
        enable = true;
        package = pkgs.podman;
        settings = {
            registries.search = [ "docker.io" ];
            containers.engine.compose_providers = [ "${pkgs.podman}/bin/podman-compose" "${pkgs.docker}/bin/docker-compose" ];
        };
    };
}
