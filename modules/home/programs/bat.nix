{
    pkgs,
    ...
}:
{
    programs.bat = {
        enable = true;
        package = pkgs.bat;
        config = {
            map-syntax = "*.hurl:HTTP Request and Response";
        };
    };
}
