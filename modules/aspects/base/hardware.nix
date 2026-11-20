{
  flake-file.inputs.disko.url = "github:nix-community/disko";

  flake.aspects.base = {
    nixos = {
      inputs,
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

      nixpkgs.config.allowUnfreePackages =
        lib.optionals config.hardware.enableAllFirmware
        [
          "broadcom-bt-firmware"
          "b43-firmware"
          "xone-dongle-firmware"
          "facetimehd-firmware"
          "facetimehd-calibration"
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

      services.udev = {
        enable = true;
        extraRules = ''
          # IO Scheduler
          # HDD
          ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
          # SSD
          ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="bfq"
          # NVMe SSD
          ACTION=="add|change", KERNEL=="nvme[0-9]*", ENV{DEVTYPE}=="disk", ATTR{queue/scheduler}="none"
        '';
      };
    };
  };
}
