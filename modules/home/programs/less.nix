{
    pkgs,
    ...
}:
{
    programs.less = {
        enable = true;
        package = pkgs.less;
        options = {
            RAW-CONTROL-CHARS = true;
        };
    };
    programs.lesspipe = {
        enable = true;
        package = pkgs.lesspipe;
    };
}
