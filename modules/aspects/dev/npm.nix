{
  den.aspects.dev = {
    homeManager = {config, ...}: {
      programs.npm = {
        enable = true;
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
    };
  };
}
