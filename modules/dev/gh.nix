{
  flake.aspects.dev = {
    homeManager = { pkgs, ... }: {
      programs.gh = {
        enable = true;
        package = pkgs.gh;
        gitCredentialHelper.enable = true;
        settings = {
          git_protocol = "ssh";
        };
      };
    };
  };
}
