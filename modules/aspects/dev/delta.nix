{
  den.aspects.dev = {
    homeManager = {config, ...}: {
      programs.delta = {
        enable = true;
        enableGitIntegration = config.programs.git.enable;
        enableJujutsuIntegration = config.programs.jujutsu.enable;
        options = {
          tabs = 4;
          side-by-side = false;
          line-numbers = true;
          syntax-theme = "Nord";
          file-modified-label = "modified:";
        };
      };
    };
  };
}
