{ pkgs, ... }:
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
}
