{ pkgs, ... }:
{
    programs.zathura = {
        enable = true;
        package = pkgs.zathura;
        options = {
            database = "sqlite";
            selection-clipboard = "clipboard";
            statusbar-h-padding = 0;
            statusbar-v-padding = 0;
            page-padding = 1;
            statusbar-home-tilde = true;
            window-title-basename = true;
            recolor-darkcolor = "#d8dee9";
            recolor-lightcolor = "#242933";
            default-bg = "#242933";
            default-fg = "#d8dee9";
            statusbar-bg = "#242933";
            statusbar-fg = "#d8dee9";
            inputbar-bg = "#242933";
            inputbar-fg = "#a3be8c";
            completion-bg = "#242933";
            completion-fg = "#d8dee9";
            completion-group-bg = "#242933";
            completion-group-fg = "#d8dee9";
            completion-highlight-bg = "#434c5e";
            completion-highlight-fg = "#d8dee9";
            notification-bg = "#3b4252";
            notification-fg = "#eceff4";
            notification-error-bg = "#bf616a";
            notification-error-fg = "#eceff4";
            notification-warning-bg = "#ebcb8b";
            notification-warning-fg = "#2e3440";
            index-bg = "#242933";
            index-fg = "#d8dee9";
            index-active-bg = "#434c5e";
            index-active-fg = "#d8dee9";
            render-loading-bg = "#242933";
            render-loading-fg = "#d8dee9";
            highlight-color = "rgba(94,129,172,0.5)";
            highlight-active-color = "rgba(136,192,208,0.5)";
            highlight-fg = "rgba(216,222,233,0.5)";
        };
        mappings = {
            u = "scroll half-up";
            d = "scroll half-down";
            D = "toggle_page_mode";
            r = "reload";
            R = "rotate";
            K = "zoom in";
            J = "zoom out";
            i = "recolor";
            p = "print";
            g = "goto top";
            ";" = "snap_to_page";
            "=" = "zoom in";
            "-" = "zoom out";
            "+" = "zoom best-fit";
            "[presentation] k" = "scroll full-up";
            "[presentation] j" = "scroll full-down";
        };
    };
}
