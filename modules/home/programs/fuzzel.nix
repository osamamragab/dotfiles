{
    pkgs,
    ...
}:
{
    programs.fuzzel = {
        enable = true;
        package = pkgs.fuzzel;
        settings = {
            main = {
                dpi-aware = "no";
                show-actions = true;
                fields = "name,filename,generic,keywords,categories,comment,exec";
                layer = "overlay";
                lines = 15;
                width = 40;
                inner-pad = 15;
                vertical-pad = 20;
                horizontal-pad = 20;
                line-height = "45px";
            };
            key-bindings = {
                clipboard-paste = "Control+Shift+p";
                custom-1 = "Mod1+1";
            };
            border = {
                width = 2;
                radius = 24;
            };
        };
    };
}
