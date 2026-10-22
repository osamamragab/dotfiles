{
  flake-file.inputs.emacs-overlay.url = "github:nix-community/emacs-overlay";

  flake.aspects.dev = {
    nixos = { inputs, ... }: {
      nixpkgs.overlays = [
        inputs.emacs-overlay.overlays.default
      ];
    };

    homeManager =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      let
        cfg = config.programs.emacs;
        scfg = config.services.emacs;
        configPath = ./emacs;
      in
      {
        programs.emacs = {
          enable = true;
          package = pkgs.emacsWithPackagesFromUsePackage {
            package = pkgs.emacs-unstable-pgtk;
            config = configPath + "/init.el";
            alwaysEnsure = true;
            extraEmacsPackages = epkgs: [
              pkgs.shellcheck
              pkgs.libtool
              pkgs.vips
              pkgs.ffmpegthumbnailer
              pkgs.poppler-utils
              pkgs.mediainfo
              (pkgs.aspellWithDicts (d: [ d.en ]))
            ];
          };
        };

        services.emacs = {
          enable = cfg.enable;
          package = cfg.package;
          client = {
            enable = true;
            arguments = [
              "-n"
              "-a"
              "emacs"
            ];
          };
          socketActivation.enable = false;
          startWithUserSession = !config.services.emacs.socketActivation.enable;
        };

        home.file.".config/emacs" = lib.mkIf cfg.enable {
          source = configPath;
          recursive = true;
        };

        home.shellAliases = lib.mkIf cfg.enable {
          emacs = "emacsclient -nca emacs";
        };

        xdg.mimeApps.defaultApplications = lib.mkIf (cfg.enable && scfg.defaultEditor) (
          lib.genAttrs [
            "text/plain"
            "text/x-c"
            "text/x-shellscript"
          ] (_: [ "emacsclient.desktop" ])
        );
      };
  };
}
