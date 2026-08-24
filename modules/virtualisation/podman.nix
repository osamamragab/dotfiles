{
    flake.aspects.virtualisation = {
        nixos = { pkgs, ... }: {
            virtualisation.podman = {
                enable = true;
                package = pkgs.podman;
                defaultNetwork.settings.dns_enabled = true;
            };
        };

        homeManager = { pkgs, ... }: {
            services.podman = {
                enable = true;
                package = pkgs.podman;
                settings = {
                    registries.search = [ "docker.io" ];
                    containers.engine.compose_providers = [
                        "${pkgs.podman-compose}/bin/podman-compose"
                        "${pkgs.docker-compose}/bin/docker-compose"
                    ];
                };
            };
        };
    };
}
