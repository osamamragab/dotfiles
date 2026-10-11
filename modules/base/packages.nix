{
  flake.aspects.base = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        git
        vis
        file
        which
        tree
        fdupes
        gnused
        gnutar
        gawk
        btop
        iotop
        iftop
        strace
        ltrace
        traceroute
        lsof
        psmisc
        ethtool
        pciutils
        usbutils
        lm_sensors
        smartmontools
      ];
    };
  };
}
