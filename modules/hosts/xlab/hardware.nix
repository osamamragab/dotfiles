{
  flake.hosts.xlab.module = {
    pkgs,
    lib,
    config,
    ...
  }: {
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
  };
}
