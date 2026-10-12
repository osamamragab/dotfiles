{
  flake.aspects.tools = {
    homeManager =
      {
        pkgs,
        osConfig ? null,
        ...
      }:
      {
        home = {
          packages =
            with pkgs;
            [
              bc
              jq
              age
              buku
              fribidi
              dragon-drop
              ffmpeg
              imagemagick
              exiftool
              firejail
              bubblewrap
              rsync
              croc
              qrencode
              zbar
              minisign
              openssl
              signify
              hashcat
              duf
              entr
            ]
            ++ lib.optional osConfig.hardware.graphics.enable pkgs.nvtopPackages.full;
          shellAliases = {
            bc = "bc -ql";
            drag = "dragon-drop -a -x";
            rsync = "rsync -vrPlu";
            ffmpeg = "ffmpeg -hide_banner";
          };
        };

        programs.pandoc = {
          enable = true;
          package = pkgs.pandoc;
        };
      };
  };
}
