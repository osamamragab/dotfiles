{ config, ... }:
{
  flake.hosts.xlab = {
    system = "x86_64-linux";
    user = "osama";
    aspects = with config.flake.aspects; [
      base
      shell
      tools
      desktop
      dev
      virtualisation
    ];
    module =
      {
        pkgs,
        lib,
        config,
        modulesPath,
        ...
      }:
      {
        imports = [
          (modulesPath + "/installer/scan/not-detected.nix")
        ];

        boot = {
          kernelPackages = pkgs.linuxPackages_zen;
          kernelModules = [
            "kvm-intel"
            "i915"
            "amdgpu"
          ];
          kernelParams = [
            "i915.enable_guc=3"
            "i915.enable_dc=4"
            "i915.fastboot=1"
            "amdgpu.runpm=0"
            "amdgpu.abmlevel=0"
            "amdgpu.gpu_recovery=1"
            "amdgpu.lockup_timeout=10000"
          ];
          extraModulePackages = [ ];
          initrd = {
            kernelModules = [ ];
            availableKernelModules = [
              "xhci_pci"
              "nvme"
              "usb_storage"
              "usbhid"
              "sd_mod"
            ];
          };
          plymouth.enable = true;
        };

        hardware = {
          cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
          graphics.extraPackages = with pkgs; [
            intel-media-driver # VA-API (iHD) userspace
            vpl-gpu-rt # oneVPL (QSV) runtime
            libvdpau-va-gl # VDPAU-only apps
          ];
          amdgpu = {
            initrd.enable = true;
            opencl.enable = true;
            overdrive = {
              enable = true;
              ppfeaturemask = "0xffffffff";
            };
          };
        };

        environment.variables = lib.mkIf config.hardware.graphics.enable {
          LIBVA_DRIVER_NAME = "radeonsi";
          VDPAU_DRIVER = "radeonsi";
        };

        disko.devices.disk.main = {
          type = "disk";
          device = "/dev/disk/by-id/nvme-KXG50ZNV512G_TOSHIBA_Z8DF717FF6GS";
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
              luks = {
                size = "100%";
                label = "luks";
                content = {
                  type = "luks";
                  name = "cryptroot";
                  settings = {
                    allowDiscards = true;
                    # keyFile = "/tmp/secret.key";
                  };
                  content = {
                    type = "btrfs";
                    extraArgs = [
                      "-L"
                      "data"
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
                        swap.swapfile.size = "18G";
                      };
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
      };
  };
}
