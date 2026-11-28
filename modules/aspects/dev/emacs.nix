{inputs, ...}: {
  flake-file.inputs.emacs-overlay.url = "github:nix-community/emacs-overlay";

  den.aspects.dev = {
    nixos = {
      nixpkgs.overlays = [inputs.emacs-overlay.overlays.default];
    };

    homeManager = {
      pkgs,
      lib,
      config,
      ...
    }: let
      cfg = config.programs.emacs;
      scfg = config.services.emacs;
      configPath = ./emacs;
    in {
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
            (pkgs.aspellWithDicts (d: [d.en]))
            epkgs.treesit-grammars.with-all-grammars
          ];
        };
      };

      services.emacs = {
        enable = cfg.enable;
        package = cfg.package;
        defaultEditor = lib.mkDefault true;
        client = {
          enable = true;
          arguments = [
            "-c"
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

      home.shellAliases = lib.mkIf scfg.enable (
        {
          emacs = "emacsclient -cna emacs";
        }
        // lib.optionalAttrs scfg.defaultEditor {
          e = "emacs";
        }
      );

      xdg.mimeApps.defaultApplications = lib.mkIf (cfg.enable && scfg.defaultEditor) (
        lib.genAttrs [
          "text/plain"
          "text/x-c"
          "text/x-shellscript"
        ] (_: ["emacsclient.desktop"])
      );
    };
  };
}
