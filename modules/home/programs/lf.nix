{
    pkgs,
    lib,
    config,
    ...
}:
let
    iconsPath = ../files/lf/icons;
    thumbDir = "${config.xdg.cacheHome}/lf/thumbnails";
    unarBin = "${pkgs.unar}/bin/unar";
    xdgOpenBin = "${pkgs.xdg-utils}/bin/xdg-open";
    cleanerScript = pkgs.writeShellScript "lfcleaner" ''
        set -eu
        file="$1"
        hash="$(sha256sum "$(readlink -f "$file")" | cut -d " " -f 1)"
        find "${thumbDir}" -name "$hash*" -delete || true
    '';
    previwerScript =
        let
            batBin = "${config.programs.bat.package or pkgs.bat}/bin/bat";
            gpgBin = "${config.programs.gpg.package or pkgs.gnupg}/bin/gpg";
            w3mBin = "${pkgs.w3m}/bin/w3m";
            lsarBin = "${pkgs.unar}/bin/lsar";
            chafaBin = "${pkgs.chafa}/bin/chafa";
            magickBin = "${pkgs.imagemagick}/bin/magick";
            pdftoppmBin = "${pkgs.poppler-utils}/bin/pdftoppm";
            mediainfoBin = "${pkgs.mediainfo}/bin/mediainfo";
            epubThumbBin = "${pkgs.gnome-epub-thumbnailer}/bin/gnome-epub-thumbnailer";
            ffmpegThumbBin = "${pkgs.ffmpegthumbnailer}/bin/ffmpegthumbnailer";
        in
        pkgs.writeShellScript "lfpreviewer" ''
            set -eu

            file="$1"
            width="$2"
            height="$3"
            posx="$4"
            thumb=""

            sixel() {
                ${chafaBin} \
                    --format sixel \
                    --polite on \
                    --animate off \
                    --size "''${width}x''${height}" \
                    --bg "#2e3440" \
                    --threshold 0.95 \
                    "$1"
            }

            thumbnailfile() {
                hash="$(sha256sum "$(readlink -f "$file")" | cut -d " " -f 1)"
                thumb="${thumbDir}/$hash"
                [ -d "${thumbDir}" ] || mkdir -p "${thumbDir}"
                [ -f "$thumb" ]
            }

            mime="$(file -bL --mime-type -- "$file")"
            case "$mime" in
            image/jpeg | image/png | image/gif | image/webp)
                sixel "$file"
                ;;
            image/*)
                thumbnailfile || ${magickBin} "$file" "$thumb.jpg"
                sixel "$thumb.jpg"
                ;;
            text/troff)
                man "$file" | ${batBin} -l man -pf --terminal-width $((width - 5))
                ;;
            text/html)
                ${w3mBin} -t "$posx" -T "$mime" -I utf-8 -O utf-8 -dump "$file"
                ;;
            text/* | */xml | application/json | application/x-ndjson)
                ${batBin} -pf --terminal-width $((width - 5)) "$file"
                ;;
            audio/* | application/octet-stream)
                ${mediainfoBin} "$file"
                ;;
            video/*)
                thumbnailfile || ${ffmpegThumbBin} -i "$file" -o "$thumb.jpg" -s 0
                sixel "$thumb.jpg"
                ;;
            */pdf)
                thumbnailfile || ${pdftoppmBin} -jpeg -f 1 -singlefile "$file" "$thumb"
                sixel "$thumb.jpg"
                ;;
            */epub+zip | */mobi*)
                thumbnailfile || ${epubThumbBin} "$file" "$thumb.jpg"
                sixel "$thumb.jpg"
                ;;
            application/*zip | application/*rar | application/*-xz)
                ${lsarBin} -- "$file"
                ;;
            application/pgp-encrypted)
                ${gpgBin} -d -- "$file"
                ;;
            esac

            exit 1
        '';
in
{
    programs.lf = {
        enable = true;
        package = pkgs.lf;
        settings = {
            shell = "sh";
            shellopts = "-eu";
            ifs = "\\n";
            icons = true;
            period = 1;
            scrolloff = 10;
            cursorpreviewfmt = "\033[7;2m";
            autoquit = true;
            cleaner = lib.toString cleanerScript;
            previewer = lib.toString previwerScript;
        };
        keybindings = {
            H = "set hidden!";
            enter = "shell";
            esc = "!true";
            x = "$$f";
            X = "!$f";
            o = "&${xdgOpenBin} $f";
            D = "delete";
            delete = "delete";
            q = "quit";
        };
        commands = {
            q = "quit";
            open = "&${xdgOpenBin} $f";
            extract = "&${unarBin} $f";
        };
    };

    xdg.configFile."lf/icons" =
        lib.mkIf
            (
                lib.pathExists iconsPath
                && config.programs.lf.enable
                && config.programs.lf.settings.icons
            )
            {
                source = iconsPath;
            };
}
