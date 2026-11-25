{
  flake.hosts.xlab = {
    system = "x86_64-linux";
    user = "osama";
    sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILIgsbWIOfq9autOqHLrP8PCoTrAOG50BPDSbWjoCQzC";
    aspects = [
      "shell"
      "tools"
      "desktop"
      "dev"
      "virtualisation"
    ];
    module = {
      pkgs,
      lib,
      config,
      ...
    }: {
      networking.wireless.enable = true;

      boot = {
        kernelPackages = pkgs.linuxPackages_zen;
        plymouth.enable = true;
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
        initrd.availableKernelModules = [
          "xhci_pci"
          "nvme"
          "usb_storage"
          "usbhid"
          "sd_mod"
        ];
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

      sops.secrets."luks_root".key = "luks/root";

      disko.devices.disk.main = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-KXG50ZNV512G_TOSHIBA_Z8DF717FF6GS";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              label = "boot";
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
                type = "luks";
                name = "cryptroot";
                passwordFile = config.sops.secrets."luks_root".path;
                settings = {
                  allowDiscards = true;
                  bypassWorkqueues = true;
                  crypttabExtraOpts = ["keyfile-timeout=10"];
                  # keyFile = "/tmp/luks.key";
                };
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
  };
}
