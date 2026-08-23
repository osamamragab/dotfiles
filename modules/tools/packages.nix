{
    flake.aspects.tools = {
        homeManager = { pkgs, ... }: {
            home.packages = with pkgs; [
                bc
                jq
                buku
                tree-sitter
                fribidi
                dragon-drop
                ffmpeg
                imagemagick
                exiftool
                firejail
                bubblewrap
                croc
                qrencode
                zbar
                minisign
                signify
                hashcat
                duf
                entr
            ];

            programs.pandoc = {
                enable = true;
                package = pkgs.pandoc;
            };
        };
    };
}
