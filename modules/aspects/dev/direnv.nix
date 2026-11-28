{
  den.aspects.dev = {
    homeManager = {config, ...}: {
      programs.direnv = {
        enable = true;
        silent = false;
        enableGitIntegration = config.programs.git.enable;
        nix-direnv.enable = config.programs.direnv.enable;
        mise.enable = config.programs.mise.enable;
      };
    };
  };
}
