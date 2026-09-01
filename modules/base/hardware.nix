{
  flake-file.inputs.disko.url = "github:nix-community/disko";

  flake.aspects.base = {
    nixos =
      {
        pkgs,
        lib,
        config,
        host,
        ...
      }:
      {
        hardware = {
          enableAllFirmware = lib.mkDefault true;
          enableRedistributableFirmware = lib.mkDefault config.hardware.enableAllFirmware;
          graphics = {
            enable = lib.mkDefault true;
            enable32Bit = lib.mkDefault config.hardware.graphics.enable;
          };
        };

        users.groups.video.members = lib.optional config.hardware.graphics.enable host.user;

        nixpkgs.config.allowUnfreePredicate = lib.mkIf config.hardware.enableAllFirmware (
          pkg:
          lib.elem (lib.getName pkg) [
            "broadcom-bt-firmware"
            "b43-firmware"
            "xone-dongle-firmware"
            "facetimehd-firmware"
            "facetimehd-calibration"
          ]
        );
      };
  };
}
