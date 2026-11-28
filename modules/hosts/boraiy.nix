{den, ...}: {
  den.hosts.boraiy = {
    class = "nixos";
    system = "x86_64-linux";
    users.x = {};
  };

  den.aspects.boraiy = {
    den.aspects.boraiy.includes = with den.aspects; [
      base
      shell
      tools
      desktop
      virtualisation
    ];

    nixos = {
      pkgs,
      config,
      ...
    }: {
      networking.wireless.enable = true;
      services.openssh.openFirewall = true;

      services.logind.settings.Login = {
        HandlePowerKey = "lock";
        HandleLidSwitch = "lock";
        HandleLidSwitchDocked = "lock";
        HandleLidSwitchExternalPower = "lock";
      };

      boot = {
        kernelPackages = pkgs.linuxPackages_zen;
        kernelModules = ["kvm-intel"];
        initrd.availableKernelModules = [
          "xhci_pci"
          "ehci_pci"
          "ahci"
          "usb_storage"
          "sd_mod"
          "rtsx_usb_sdmmc"
        ];
      };

      hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;

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
                mountOptions = ["defaults" "umask=0077"];
              };
            };
            root = {
              label = "root";
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-f"];
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = ["noatime" "compress=zstd"];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = ["noatime" "compress=zstd"];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = ["noatime" "compress=zstd"];
                  };
                  "/log" = {
                    mountpoint = "/var/log";
                    mountOptions = ["noatime" "compress=zstd"];
                  };
                  "/swap" = {
                    mountpoint = "/var/swap";
                    mountOptions = ["noatime" "nodatacow" "compress=no"];
                    swap.swapfile.size = "18G";
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
        memoryPercent = 30;
      };

      services.btrfs.autoScrub = {
        enable = true;
        interval = "weekly";
        fileSystems = ["/"];
      };
    };

    homeManager = {
      programs.noctalia.settings.idle.behavior.suspend.enabled = false;
    };
  };
}
