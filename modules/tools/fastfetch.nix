{
  flake.aspects.tools = {
    homeManager = { pkgs, ... }: {
      programs.fastfetch = {
        enable = true;
        package = pkgs.fastfetch;
      };
    };
  };
}
