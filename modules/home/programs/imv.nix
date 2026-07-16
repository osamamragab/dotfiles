{
    pkgs,
    config,
    ...
}:
{
    programs.imv = {
        enable = true;
        package = pkgs.imv;
        settings = {
            options = {
                # NOTE: home-manager sets binds before options, and imv has
                # a bug (?) where it clears all bindings (including user-defined)
                # set before suppress_default_binds option; disabling it for now.
                # suppress_default_binds = true;
                background = "2e3440";
                overlay = "true";
                overlay_font = "monospace:14";
                overlay_text_color = "eceff4";
                overlay_background_color = "2e3440";
                overlay_background_alpha = "ff";
                overlay_position_bottom = true;
            };
            binds =
                let
                    # using scripts because imv cannot parse long lines (sigh).
                    wallpaperScript = pkgs.writeShellScript "imv-wallpaper" ''
                        set -eu
                        ${config.programs.noctalia.package}/bin/noctalia msg wallpaper-set "$imv_current_file"
                    '';
                    infoScript = pkgs.writeShellScript "imv-info" ''
                        set -eu
                        info="$(${pkgs.mediainfo}/bin/mediainfo "$imv_current_file")"
                        ${pkgs.libnotify}/bin/notify-send -a imv "$info"
                    '';
                    copyScript = pkgs.writeShellScript "imv-copy" ''
                        set -eu
                        ${pkgs.wl-clipboard}/bin/wl-copy <"$imv_current_file"
                        ${pkgs.libnotify}/bin/notify-send -a imv "$imv_current_file copied to clipboard"
                    '';
                    dragScript = pkgs.writeShellScript "imv-drag" ''
                        set -eu
                        setsid -f ${pkgs.dragon-drop}/bin/dragon-drop -x "$imv_current_file"
                    '';
                    flipScript = pkgs.writeShellScript "imv-flip" ''
                        set -eu
                        ${pkgs.imagemagick}/bin/magick mogrify -flop "$imv_current_file"
                    '';
                    rotateScript = pkgs.writeShellScript "imv-rotate" ''
                        set -eu
                        ${pkgs.imagemagick}/bin/magick mogrify -rotate "$1" "$imv_current_file"
                    '';
                    deleteScript = pkgs.writeShellScript "imv-delete" ''
                        set -eu
                        [ "$1" = "-f" ] ||
                            [ "$(printf "no\nyes" | menu -p "delete $imv_current_file?")" = "yes" ] ||
                            exit 1
                        rm "$imv_current_file"
                        ${pkgs.libnotify}/bin/notify-send -a imv "$imv_current_file deleted"
                        ${config.programs.imv.package}/bin/imv-msg "$imv_pid" close
                    '';
                in
                {
                    q = "quit";
                    x = "close";
                    f = "fullscreen";
                    n = "next";
                    p = "prev";
                    "<Left>" = "prev";
                    "<bracketleft>" = "prev";
                    "<Right>" = "next";
                    "<bracketright>" = "next";
                    gg = "goto 1";
                    "<Shift+G>" = "goto -1";
                    j = "pan 0 -50";
                    k = "pan 0 50";
                    h = "pan 50 0";
                    l = "pan -50 0";
                    "<Up>" = "zoom 1";
                    "<Shift+plus>" = "zoom 1";
                    i = "zoom 1";
                    o = "zoom -1";
                    "<Down>" = "zoom -1";
                    "<minus>" = "zoom -1";
                    r = "rotate by 90";
                    "<Shift+R>" = "rotate by -90";
                    d = "overlay";
                    "<Shift+P>" = ''exec echo "$imv_current_file"'';
                    c = "center";
                    s = "scaling next";
                    "<Shift+S>" = "upscaling next";
                    a = "zoom actual";
                    "<Ctrl+r>" = "reset";
                    "<period>" = "next_frame";
                    "<space>" = "toggle_playing";
                    t = "slideshow +1";
                    "<Shift+T>" = "slideshow -1";
                    "<Ctrl+x>w" = "exec ${builtins.toString wallpaperScript}";
                    "<Ctrl+x>r" = "exec ${builtins.toString rotateScript} 90";
                    "<Ctrl+x><Shift+R>" = "exec ${builtins.toString rotateScript} -90";
                    "<Ctrl+x>f" = "exec ${builtins.toString flipScript}";
                    "<Ctrl+x>i" = "exec ${builtins.toString infoScript}";
                    "<Ctrl+x>d" = "exec ${builtins.toString deleteScript}";
                    "<Ctrl+x><Shift+D>" = "exec ${builtins.toString deleteScript} -f";
                    "<Ctrl+x>y" = "exec ${builtins.toString copyScript}";
                    "<Ctrl+x>g" = "exec ${builtins.toString dragScript}";
                };
        };
    };
}
