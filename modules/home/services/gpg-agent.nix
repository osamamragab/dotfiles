{
    pkgs,
    config,
    ...
}:
{
    home.packages = [ pkgs.gcr ];
    services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
        grabKeyboardAndMouse = true;
        maxCacheTtl = 1800;
        defaultCacheTtl = 600;
        pinentry = {
            package = pkgs.pinentry-gnome3;
            program = "pinentry-gnome3";
        };
    };
}
