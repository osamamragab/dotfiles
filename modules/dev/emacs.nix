{
  flake-file.inputs.emacs-overlay.url = "github:nix-community/emacs-overlay";

  flake.aspects.dev = {
    nixos = {inputs, ...}: {
      nixpkgs.overlays = [
        inputs.emacs-overlay.overlays.default
      ];
    };

    homeManager = {
      inputs,
      pkgs,
      lib,
      config,
      osConfig ? {},
      ...
    }: let
      cfg = config.programs.emacs;
      scfg = config.services.emacs;
      configPath = ./emacs;
    in {
      nixpkgs.overlays = lib.mkIf (!(osConfig.home-manager.useGlobalPkgs or false)) [
        inputs.emacs-overlay.overlays.default
      ];

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
