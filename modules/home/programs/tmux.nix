{
    pkgs,
    lib,
    config,
    ...
}:
{
    programs.tmux = {
        enable = true;
        package = pkgs.tmux;
        aggressiveResize = false;
        baseIndex = 1;
        escapeTime = 0;
        clock24 = true;
        keyMode = "vi";
        historyLimit = 10000;
        mouse = false;
        secureSocket = true;
        prefix = "C-a";
        terminal = "tmux-256color";
        extraConfig = ''
            set -sa terminal-overrides ",tmux-256color*:Tc"

            bind r source ~/.config/tmux/tmux.conf
            set -gs renumber-windows on
            set -gs copy-command "wl-copy"

            set -gw status-style "bg=color0 fg=color15"
            set -gw window-status-current-style "bg=color8"
            set -gw mode-style "bg=color8"
            set -gw message-style "bg=color0 fg=color15"
            set -gw message-command-style "bg=color0 fg=color15"

            set -gw mode-keys vi
            bind -T copy-mode-vi v send -X begin-selection
            bind -T copy-mode-vi V send -X select-line
            bind -T copy-mode-vi y send -X copy-pipe-and-cancel
            bind -rn M-Tab last-window
            bind -rn M-j next-window
            bind -rn M-k previous-window
            bind -r k select-pane -U
            bind -r j select-pane -D
            bind -r h select-pane -L
            bind -r l select-pane -R
        '';
    };

    home.file."${config.xdg.binHome}/tmuxx" = lib.mkIf config.programs.tmux.enable {
        source =
            let
                fzfBin = "${config.programs.fzf.package or pkgs.fzf}/bin/fzf";
                tmuxBin = "${config.programs.tmux.package or pkgs.tmux}/bin/tmux";
            in
            pkgs.writeShellScript "tmuxx" ''
                set -eu

                PROJECTS_DIR="${config.xdg.userDirs.projects}"

                dirsel() {
                    find "$PRODJECTS_DIR" -mindepth 2 -maxdepth 2 -type d -printf "%T@ %P\n" |
                        sort -nr |
                        cut -d " " -f 2- |
                        ${fzfBin}
                }

                case "''${1:--}" in
                .)
                    dir="$(pwd)"
                    shift
                    ;;
                -)
                    dir="$PRODJECTS_DIR/$(dirsel)" || exit $?
                    [ $# -gt 0 ] && shift
                    ;;
                *)
                    dir="$(readlink -f "$1")"
                    shift
                    ;;
                esac

                [ -d "$dir" ] || {
                    echo "$(basename "$0"): '$dir' is not a diretory" >&2
                    exit 1
                }
                name="$(basename "$dir")"

                [ $# -gt 1 ] && {
                    ${tmuxBin} new -d -c "$dir" -s "$name" -n "$1"
                    shift
                }

                for win; do
                    ${tmuxBin} new-window -d -t "$name" -c "$dir" -n "$win"
                done

                exec ${tmuxBin} new -A -c "$dir" -s "$name"
            '';
    };
}
