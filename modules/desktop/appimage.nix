{
  flake.aspects.desktop = {
    nixos =
      { pkgs, ... }:
      let
        mountOptions = [
          "ro"
          "x-gvfs-hide"
          "resolve-symlinks"
        ];
      in
      {
        fonts.fontDir.enable = true;

        system.fsPackages = [ pkgs.bindfs ];

        fileSystems."/usr/share/fonts" = {
          device = "/run/current-system/sw/share/X11/fonts";
          fsType = "fuse.bindfs";
          options = mountOptions;
        };

        fileSystems."/usr/share/icons" = {
          device = "/run/current-system/sw/share/icons";
          fsType = "fuse.bindfs";
          options = mountOptions;
        };

        fileSystems."/usr/share/themes" = {
          device = "/run/current-system/sw/share/themes";
          fsType = "fuse.bindfs";
          options = mountOptions;
        };

        programs.appimage = {
          enable = true;
          binfmt = true;
          package = pkgs.appimage-run;
        };
      };
  };
}
