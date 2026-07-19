{
    pkgs,
    ...
}:
{
    programs.aria2 = {
        enable = true;
        package = pkgs.aria2;
        systemd.enable = false;
        settings = {
            continue = true;
            split = 8;
            max-connection-per-server = 8;
            min-split-size = "5MiB";
        };
    };
}
