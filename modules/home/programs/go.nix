{
    pkgs,
    config,
    ...
}:
{
    programs.go = {
        enable = true;
        package = pkgs.go;
        telemetry.mode = "off";
        env = {
            GOPATH = [ "${config.xdg.dataHome}/go" ];
            GOMODCACHE = "${config.xdg.cacheHome}/go/mod";
        };
    };
}
