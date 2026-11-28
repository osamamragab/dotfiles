{
  den.aspects.virtualisation = {
    nixos = {
      lib,
      config,
      host,
      ...
    }: {
      virtualisation.podman = {
        enable = true;
        dockerCompat = !config.virtualisation.docker.enable;
        defaultNetwork.settings.dns_enabled = true;
      };

      users.groups.podman.members =
        host.users
        |> lib.mapAttrsToList (_: u: u.userName)
        |> lib.optionals config.virtualisation.podman.enable;
    };

    homeManager = {
      pkgs,
      osConfig ? null,
      ...
    }: {
      services.podman = {
        enable = osConfig.virtualisation.podman.enable or true;
        settings = {
          registries.search = ["docker.io"];
          containers.engine.compose_providers = [
            "${pkgs.podman-compose}/bin/podman-compose"
            "${pkgs.docker-compose}/bin/docker-compose"
          ];
        };
      };
    };
  };
}
