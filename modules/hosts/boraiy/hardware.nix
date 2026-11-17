{
  flake.hosts.boraiy = {
    module = {config, ...}: {
      boot = {
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

      hardware.cpu.intel.updateMicrocode =
        config.hardware.enableRedistributableFirmware;
    };
  };
}
