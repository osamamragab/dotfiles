{
  den.aspects.virtualisation = {
    nixos = {config, ...}: {
      virtualisation.docker = {
        enable = true;
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
