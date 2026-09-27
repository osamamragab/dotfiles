{
  flake.aspects.tools = {
    homeManager =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      let
        cfg = config.programs.password-store;
        menuBin = "${config.xdg.binHome}/menu";
        passBin = "${cfg.package}/bin/pass";
        wlCopyBin = "${pkgs.wl-clipboard}/bin/wl-copy";
        notifySendBin = "${pkgs.libnotify}/bin/notify-send";
      in
      {
        programs.password-store = {
          enable = true;
          package = pkgs.pass.withExtensions (exts: [
            exts.pass-otp
          ]);
          settings = {
            PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
            PASSWORD_STORE_GPG_OPTS = "--no-throw-keyids";
          };
        };

        home.shellAliases = lib.mkIf cfg.enable {
          pass = ''
            _pass() {
              ed="''${EDITOR:-vi}"
              case "$ed" in
              vim | nvim) ed="$ed --noplugin" ;;
              esac
              env EDITOR="$ed" pass "$@"
              unset ed
            }; _pass \
          '';
        };

        home.file."${config.xdg.binHome}/passmenu" = lib.mkIf cfg.enable {
          source = pkgs.writeShellScript "passmenu" ''
            set -eu

            pass_list() {
              find "${cfg.settings.PASSWORD_STORE_DIR}" \
                -type f \
                -name "*.gpg" \
                -printf "%P\n" |
                sed 's/\.gpg$//'
            }

            case "''${1:-}" in
            -l | -list | --list)
              pass_list
              exit 0
              ;;
            esac

            app="$(basename "$0")"
            sel="''${1:-$(pass_list | ${menuBin} -p "Passwords> ")}" || exit 1
            content="$(${passBin} "$sel")" || {
              ec=$?
              echo "$app: pass command failed" >&2
              ${notifySendBin} -a "$app" -u critical error "pass command failed"
              exit $ec
            }
            field="$(
              echo "$content" |
              sed "1s/.*/password/;s/otpauth:\/\/.*/otp/;s/^\([^:]*\)\s*:\s*.*/\1/" |
              ${menuBin} -p "Password Fields: $sel> "
            )" || exit $?
            case "$field" in
            password) pass="$(echo "$content" | sed 1q)" ;;
            otp) pass="$(${passBin} otp code "$sel")" ;;
            *) pass="$(echo "$content" | sed -n "s/^$field\s\+\?:\s\+\?\(.*\)/\1/p")" ;;
            esac

            printf "%s" "$pass" | ${wlCopyBin} --sensitive --type text/plain --foreground --trim-newline
            ${notifySendBin} -a "$app" "$sel" "$field copied to clipboard"
          '';
        };
      };
  };
}
