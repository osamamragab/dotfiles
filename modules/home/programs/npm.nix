{
    pkgs,
    config,
    ...
}:
{
    programs.npm = {
        enable = true;
        package = pkgs.nodejs;
        settings = {
            prefix = "${config.xdg.dataHome}/npm";
            cache = "${config.xdg.cacheHome}/npm";
            init-module = "${config.xdg.configHome}/npm/init.js";
            engine-strict = true;
            foreground-scripts = true;
            update-notifier = false;
            fund = false;
        };
    };
}
