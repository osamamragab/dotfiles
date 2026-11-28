{
  den.aspects.dev = {
    homeManager = {
      programs.gh = {
        enable = true;
        gitCredentialHelper.enable = true;
        settings = {
          git_protocol = "ssh";
        };
      };
    };
  };
}
