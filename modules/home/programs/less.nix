{
    pkgs,
    ...
}:
{
    programs.less = {
        enable = true;
        package = pkgs.less;
        options = {
            quiet = true;
            no-init = true;
            wordwrap = true;
            use-color = true;
            ignore-case = true;
            hilite-unread = true;
            RAW-CONTROL-CHARS = true;
            quit-if-one-screen = false;
        };
    };
    programs.lesspipe = {
        enable = true;
        package = pkgs.lesspipe;
    };
}
