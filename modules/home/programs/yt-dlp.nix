{
    pkgs,
    lib,
    config,
    ...
}:
{
    programs.yt-dlp = {
        enable = true;
        package = pkgs.yt-dlp;
        settings = {
            continue = true;
            downloader = "aria2c";
            downloader-args = "aria2c:'-c -x8 -s8 -k5MiB'";
            sub-langs = "all";
            embed-subs = true;
            embed-metadata = true;
            embed-thumbnail = true;
            bidi-workaround = true;
            sponsorblock-mark = "all";
        };
    };

    home.file."${config.xdg.binHome}/dl" = lib.mkIf config.programs.yt-dlp.enable {
        source = pkgs.writeShellScript "dl" ''
            set -eu
            for arg; do
                case "$arg" in
                -a) format="bestaudio[ext=m4a]/bestaudio[ext=mp3]/bestaudio" ;;
                -v) format="bestvideo[ext=mp4]/bestvideo" ;;
                -pl) output="%(playlist_title)s/%(title)s.%(ext)s" ;;
                -pls) output="%(playlist_title)s/%(playlist_index)s. %(title)s.%(ext)s" ;;
                --)
                    shift
                    break
                    ;;
                -*)
                    echo "$(basename "$0"): unknown option: $arg" >&2
                    exit 1
                    ;;
                *) continue ;;
                esac
                shift
            done
            exec yt-dlp -f "''${format:-22/best[ext=mp4]/best}" -o "''${output:-%(title)s.%(ext)s}" -- "$@"
        '';
    };
}
