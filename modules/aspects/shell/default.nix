{
  flake.aspects.shell = {
    homeManager = {
      home.shell.enableShellIntegration = true;
    };
  };
}
