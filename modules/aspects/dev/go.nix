{
  den.aspects.dev = {
    homeManager = {config, ...}: {
      programs.go = {
        enable = true;
        telemetry.mode = "off";
        env = {
          GOPATH = ["${config.xdg.dataHome}/go"];
          GOMODCACHE = "${config.xdg.cacheHome}/go/mod";
        };
      };
    };
  };
}
