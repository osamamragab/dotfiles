{
    pkgs,
    lib,
    config,
    ...
}:
let
    iconsPath = ../files/lf/icons;
    thumbDir = "${config.xdg.cacheHome}/lf/thumbnails";
    cleanerScript = pkgs.writeShellScript "lfcleaner" ''
        set -eu
        file="$1"
        hash="$(sha256sum "$(readlink -f "$file")" | cut -d " " -f 1)"
        find "${thumbDir}" -name "$hash*" -delete || true
    '';
    previwerScript = pkgs.writeShellScript "lfpreviewer" ''
        set -eu

        file="$1"
        width="$2"
        height="$3"
        posx="$4"
        thumb=""

        sixel() {
            ${pkgs.chafa}/bin/chafa \
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
            [ -d "${thumbDir}" ] ||
                mkdir -p "${thumbDir}"
            [ -f "$thumb" ]
        }

        mime="$(file -bL --mime-type -- "$file")"
        case "$mime" in
        image/jpeg | image/png | image/gif | image/webp)
            sixel "$file"
            ;;
        image/*)
            thumbnailfile ||
            ${pkgs.imagemagick}/bin/magick "$file" "$thumb.jpg"
            sixel "$thumb.jpg"
            ;;
        text/troff)
            ${pkgs.bat-extras.batman}/bin/batman "$file"
            ;;
        text/html)
            ${pkgs.w3m}/bin/w3m -t "$posx" -T "$mime" -I utf-8 -O utf-8 -dump "$file"
            ;;
        text/* | */xml | application/json | application/x-ndjson)
            ${pkgs.bat}/bin/bat -pf --terminal-width $((width - 5)) "$file"
            ;;
        audio/* | application/octet-stream)
            ${pkgs.mediainfo}/bin/mediainfo "$file"
            ;;
        video/*)
            thumbnailfile ||
                ${pkgs.ffmpegthumbnailer}/bin/ffmpegthumbnailer -i "$file" -o "$thumb.jpg" -s 0
            sixel "$thumb.jpg"
            ;;
        */pdf)
            thumbnailfile ||
                ${pkgs.poppler-utils}/bin/pdftoppm -jpeg -f 1 -singlefile "$file" "$thumb"
            sixel "$thumb.jpg"
            ;;
        */epub+zip | */mobi*)
            thumbnailfile ||
                ${pkgs.gnome-epub-thumbnailer}/bin/gnome-epub-thumbnailer "$file" "$thumb.jpg"
            sixel "$thumb.jpg"
            ;;
        application/*zip | application/*rar | application/*-xz)
            ${pkgs.unar}/bin/lsar -- "$file"
            ;;
        application/pgp-encrypted)
            ${config.programs.gpg.package or pkgs.gnupg}/bin/gpg -d -- "$file"
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
            cleaner = builtins.toString cleanerScript;
            previewer = builtins.toString previwerScript;
        };
        keybindings = {
            H = "set hidden!";
            enter = "shell";
            esc = "!true";
            x = "$$f";
            X = "!$f";
            o = "&xdg-open $f";
            D = "delete";
            delete = "delete";
            q = "quit";
        };
        commands = {
            q = "quit";
            open = "&xdg-open $f";
            extract = "&${pkgs.unar}/bin/unar $f";
        };
    };

    xdg.configFile."lf/icons" =
        lib.mkIf
            (
                builtins.pathExists iconsPath
                && config.programs.lf.enable
                && config.programs.lf.settings.icons
            )
            {
                source = iconsPath;
            };
}
