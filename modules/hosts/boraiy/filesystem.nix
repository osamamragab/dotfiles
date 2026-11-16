{
  flake.hosts.boraiy.module = {
    disko.devices.disk.main = {
      type = "disk";
      device = "/dev/disk/by-id/ata-WDC_WD5000LPLX-08ZNTT0_WD-WX61A79EKRZR";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            label = "boot";
            name = "ESP";
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "defaults"
                "umask=0077"
              ];
            };
          };
          root = {
            size = "100%";
            label = "root";
            content = {
              type = "btrfs";
              extraArgs = [
                "-L"
                "root"
                "-f"
              ];
              subvolumes = {
                "/root" = {
                  mountpoint = "/";
                  mountOptions = [
                    "subvol=root"
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "/home" = {
                  mountpoint = "/home";
                  mountOptions = [
                    "subvol=home"
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "subvol=nix"
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "/log" = {
                  mountpoint = "/var/log";
                  mountOptions = [
                    "subvol=log"
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "/swap" = {
                  mountpoint = "/var/swap";
                  mountOptions = [
                    "subvol=swap"
                    "noatime"
                    "nodatacow"
                    "compress=no"
                  ];
                  swap.swapfile.size = "8G";
                };
              };
            };
          };
        };
      };
    };

    fileSystems = {
      "/var/log".neededForBoot = true;
      "/var/swap".neededForBoot = true;
    };

    zramSwap = {
      enable = true;
      algorithm = "zstd";
      priority = 5;
      memoryPercent = 50;
    };

    services.btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
      fileSystems = ["/"];
    };
  };
}
