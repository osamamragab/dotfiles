{ ... }:
{
    programs.readline = {
        enable = true;
        includeSystemConfig = true;
        variables = {
            editing-mode ="vi";
            bell-style = "none";
            meta-flag = true;
            input-meta = true;
            output-meta = true;
            convert-meta = false;
            completion-ignore-case = true;
            completion-prefix-display-length = 2;
            show-all-if-ambiguous = true;
            show-all-if-unmodified = true;
            mark-symlinked-directories = true;
            match-hidden-files = false;
            page-completions = false;
            completion-query-items = 200;
            visible-stats = true;
            colored-stats = true;
            skip-completed-text = true;
        };
    };
}
