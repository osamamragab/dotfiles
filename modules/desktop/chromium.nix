{
  flake.aspects.desktop = {
    homeManager = { pkgs, ... }: {
      programs.chromium = {
        enable = true;
        package = pkgs.ungoogled-chromium;
      };
    };
  };
}
