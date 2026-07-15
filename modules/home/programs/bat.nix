{
    pkgs,
    ...
}:
{
    programs.bat = {
        enable = true;
        package = pkgs.bat;
        config = {
            theme = "Nord";
            map-syntax = "*.hurl:HTTP Request and Response";
        };
    };
}
