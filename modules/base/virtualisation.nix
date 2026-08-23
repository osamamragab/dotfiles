{
    flake.aspects.virtualisation = {
        nixos =
            {
                pkgs,
                lib,
                config,
                host,

                ...
            }:
            {
                virtualisation = {
                    docker = {
                        enable = true;
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

                users.groups.kvm.members = [ host.user ];
            };

        homeManager = { pkgs, ... }: {
            services.podman = {
                enable = true;
                package = pkgs.podman;
                settings = {
                    registries.search = [ "docker.io" ];
                    containers.engine.compose_providers = [
                        "${pkgs.podman}/bin/podman-compose"
                        "${pkgs.docker}/bin/docker-compose"
                    ];
                };
            };
        };
    };
}
