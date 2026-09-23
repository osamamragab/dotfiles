{
  flake.aspects.virtualisation = {
    nixos = { pkgs, config, ... }: {
      virtualisation.docker = {
        enable = true;
        package = pkgs.docker;
        storageDriver = "overlay2";
        rootless = {
          enable = true;
          setSocketVariable = true;
          daemon.settings = {
            storage-driver = config.virtualisation.docker.storageDriver;
          };
        };
      };
    };
  };
}
