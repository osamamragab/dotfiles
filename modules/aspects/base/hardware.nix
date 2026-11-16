{
  flake-file.inputs.disko.url = "github:nix-community/disko";

  flake.aspects.base = {
    nixos = {
      inputs,
      pkgs,
      lib,
      config,
      host,
      modulesPath,
      ...
    }: {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        inputs.disko.nixosModules.disko
      ];

      hardware = {
        enableAllFirmware = lib.mkDefault true;
        enableRedistributableFirmware = lib.mkDefault config.hardware.enableAllFirmware;
        graphics = {
          enable = lib.mkDefault true;
          enable32Bit = lib.mkDefault config.hardware.graphics.enable;
        };
      };

      users.groups.video.members = lib.optional config.hardware.graphics.enable host.user;

      nixpkgs.config.allowUnfreePackages =
        lib.optionals config.hardware.enableAllFirmware
        [
          "broadcom-bt-firmware"
          "b43-firmware"
          "xone-dongle-firmware"
          "facetimehd-firmware"
          "facetimehd-calibration"
        ];
    };
  };
}
