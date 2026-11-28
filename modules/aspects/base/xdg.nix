{
  den.aspects.base = {
    homeManager = {
      lib,
      config,
      ...
    }: let
      homeDir = config.home.homeDirectory;
    in {
      xdg = {
        enable = true;
        localBinInPath = true;
        configHome = "${homeDir}/.config";
        cacheHome = "${homeDir}/.cache";
        dataHome = "${homeDir}/.local/share";
        stateHome = "${homeDir}/.local/state";
        binHome = "${homeDir}/.local/bin";
        mimeApps.enable = true;
        terminal-exec.enable = true;
        userDirs = {
          enable = true;
          createDirectories = true;
          setSessionVariables = false;
          desktop = "${homeDir}";
          projects = "${homeDir}/src";
          download = "${homeDir}/dls";
          documents = "${homeDir}/docs";
          publicShare = "${homeDir}/docs/share";
          templates = "${homeDir}/docs/templates";
          music = "${homeDir}/docs/music";
          videos = "${homeDir}/docs/vids";
          pictures = "${homeDir}/docs/pics";
        };
      };

      home = {
        preferXdgDirectories = config.xdg.enable;
        shellAliases = lib.mkIf config.xdg.enable {
          open = "xdg-open";
        };
      };
    };
  };
}
