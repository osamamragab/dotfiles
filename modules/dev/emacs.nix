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
        cfg = config.programs.emacs;
      in
      {
        programs.emacs = {
          enable = true;
          package = pkgs.emacs-pgtk;
          extraPackages =
            epkgs: with epkgs; [
              vterm
            ];
        };

        services.emacs = {
          enable = cfg.enable;
          package = cfg.finalPackage;
          client = {
            enable = true;
            arguments = [
              "-n"
              "-c"
              "-a"
              "emacs"
            ];
          };
          socketActivation.enable = false;
          startWithUserSession = !config.services.emacs.socketActivation.enable;
        };

        home.file.".config/emacs" = lib.mkIf cfg.enable {
          source = ./emacs;
          recursive = true;
        };

        home.shellAliases = lib.mkIf cfg.enable {
          emacs = "emacsclient -nca emacs";
        };
      };
  };
}
