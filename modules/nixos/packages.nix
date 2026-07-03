{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
		git
        file
        which
        tree
        gnused
        gnutar
        gawk
        zstd
        btop
        iotop
        iftop
        strace
        ltrace
        lsof
        sysstat
        lm_sensors
        pciutils
        usbutils
        ethtool
    ];
}
