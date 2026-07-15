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
        extraModulePackages = [ ];
        initrd = {
            kernelModules = [ "amdgpu" ];
            availableKernelModules = [
                "xhci_pci"
                "nvme"
                "usb_storage"
                "usbhid"
                "sd_mod"
            ];
        };
        extraModprobeConfig = lib.mkAfter ''
            options i915   enable_guc=3 enable_dc=4 fastboot=1
            options amdgpu runpm=0 abmlevel=0 gpu_recovery=1 lockup_timeout=10000 ppfeaturemask=0xffffffff
        '';
    };

    hardware = {
        enableAllFirmware = lib.mkDefault true;
        enableRedistributableFirmware = lib.mkDefault config.hardware.enableAllFirmware;
        cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
        graphics = {
            enable = true;
            enable32Bit = true;
        };
        amdgpu = {
            initrd.enable = true;
            opencl.enable = true;
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
