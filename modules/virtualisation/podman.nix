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
        virtualisation.podman = {
          enable = true;
          package = pkgs.podman;
          dockerCompat = !config.virtualisation.docker.enable;
          defaultNetwork.settings.dns_enabled = true;
        };

        users.users.${host.user} = lib.mkIf config.virtualisation.podman.enable {
          extraGroups = [ "podman" ];
          subGidRanges = [
            {
              count = 65536;
              startGid = 100000;
            }
          ];
          subUidRanges = [
            {
              count = 65536;
              startUid = 100000;
            }
          ];
        };
      };

    homeManager =
      {
        pkgs,
        osConfig ? null,
        ...
      }:
      {
        services.podman = {
          enable = osConfig.virtualisation.podman.enable or true;
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
