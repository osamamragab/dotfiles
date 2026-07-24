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

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    boot = {
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
    };

    hardware = {
        enableAllFirmware = lib.mkDefault true;
        enableRedistributableFirmware = lib.mkDefault config.hardware.enableAllFirmware;
        cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
        graphics = {
            enable = true;
            enable32Bit = true;
            extraPackages = with pkgs; [
                intel-media-driver # VA-API (iHD) userspace
                vpl-gpu-rt         # oneVPL (QSV) runtime
                libvdpau-va-gl     # VDPAU-only apps
            ];
        };
        amdgpu = {
            initrd.enable = true;
            opencl.enable = true;
            overdrive = {
                enable = true;
                ppfeaturemask = "0xffffffff";
            };
        };
        bluetooth = {
            enable = true;
            package = pkgs.bluez;
            powerOnBoot = true;
            settings = {
                General = {
                    ControllerMode = "bredr";
                    Experimental = true;
                    FastConnectable = true;
                    ClassicBondedOnly = true;
                };
                Policy = {
                    AutoEnable = true;
                };
            };
        };
    };

    environment.variables = lib.mkIf config.hardware.graphics.enable {
        LIBVA_DRIVER_NAME = "radeonsi";
        VDPAU_DRIVER = "radeonsi";
    };

    nixpkgs.config.allowUnfreePredicate =
        lib.mkIf config.hardware.enableAllFirmware
            (
                pkg:
                builtins.elem (lib.getName pkg) [
                    "broadcom-bt-firmware"
                    "b43-firmware"
                    "xone-dongle-firmware"
                    "facetimehd-firmware"
                    "facetimehd-calibration"
                ]
            );
}
