{
  flake.aspects.virtualisation = {
    nixos = { pkgs, ... }: {
      virtualisation.docker = {
        enable = true;
        package = pkgs.docker;
        storageDriver = "overlay2";
        rootless = {
          enable = true;
          setSocketVariable = true;
        };
      };
    };
  };
}
