{
  den.aspects.base = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        git
        vis
        file
        tree
        gawk
        gnused
        gnutar
        lsof
        btop
        iotop
        which
        iftop
        psmisc
        strace
        ltrace
        parted
        fdupes
        ethtool
        pciutils
        usbutils
        lm_sensors
        traceroute
        smartmontools
      ];
    };
  };
}
