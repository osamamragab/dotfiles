{ config, ... }:
{
  flake.hosts.boraiy = {
    system = "x86_64-linux";
    user = "x";
    aspects = with config.flake.aspects; [
      base
      shell
      tools
      desktop
      virtualisation
    ];
    module =
      {
        pkgs,
        config,
        host,
        modulesPath,
        ...
      }:
      {
        imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

        boot = {
          kernelPackages = pkgs.linuxPackages_zen;
          kernelModules = [ "kvm-intel" ];
          kernelParams = [ ];
          extraModulePackages = [ ];
          initrd = {
            kernelModules = [ ];
            availableKernelModules = [
              "xhci_pci"
              "ehci_pci"
              "ahci"
              "usb_storage"
              "sd_mod"
              "rtsx_usb_sdmmc"
            ];
          };
          plymouth.enable = true;
        };

        hardware.cpu.intel.updateMicrocode =
          config.hardware.enableRedistributableFirmware;

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
          fileSystems = [ "/" ];
        };

        networking.wireless.enable = true;

        services.openssh = {
          enable = true;
          openFirewall = true;
          settings = {
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
            PermitRootLogin = "no";
            AllowUsers = [ host.user ];
            MaxAuthTries = 3;
            PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
          };
        };
      };
  };
}
