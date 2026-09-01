{
  flake.aspects.tools = {
    homeManager = { pkgs, ... }: {
      programs.fd = {
        enable = true;
        package = pkgs.fd;
        ignores = [
          ".git/"
        ];
      };
    };
  };
}
