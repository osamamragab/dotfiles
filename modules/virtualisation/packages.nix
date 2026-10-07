{
  flake.aspects.virtualisation = {
    nixos =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      {
        environment.systemPackages = lib.optional config.virtualisation.podman.enable pkgs.distrobox;
      };
  };
}
