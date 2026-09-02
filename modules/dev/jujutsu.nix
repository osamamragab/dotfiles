{
  flake.aspects.dev = {
    homeManager =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      let
        gitSettings = config.programs.git.settings or { };
        backendMap = {
          openpgp = "gpg";
          x509 = "gpgsm";
          ssh = "ssh";
        };
      in
      {
        programs.jujutsu = {
          enable = true;
          package = pkgs.jujutsu;
          ediff = config.programs.emacs.enable;
          settings = {
            user = lib.mkIf (gitSettings ? user && gitSettings.user != null) {
              name = gitSettings.user.name;
              email = gitSettings.user.email;
            };
            signing = {
              behaviour = "own";
              key = gitSettings.user.signingKey or null;
              backend = lib.getAttr gitSettings.gpg.format backendMap;
              backends = {
                gpg.program = gitSettings.gpg.openpgp.program;
                gpgsm.program = gitSettings.gpg.x509.program;
                ssh.program = gitSettings.gpg.ssh.program;
              };
            };
          };
        };
      };
  };
}
