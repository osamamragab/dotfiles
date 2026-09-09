{
  flake.aspects.tools = {
    homeManager = { pkgs, ... }: {
      home = {
        packages = with pkgs; [
          bc
          jq
          age
          buku
          tree-sitter
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
          signify
          hashcat
          duf
          entr
        ];
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
