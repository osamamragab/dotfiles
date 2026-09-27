{
  flake.aspects.desktop = {
    homeManager =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      let
        cfg = config.xdg;
        homeDir = config.home.homeDirectory;
      in
      {
        xdg = {
          enable = true;
          localBinInPath = true;
          configHome = "${homeDir}/.config";
          cacheHome = "${homeDir}/.cache";
          dataHome = "${homeDir}/.local/share";
          stateHome = "${homeDir}/.local/state";
          binHome = "${homeDir}/.local/bin";
          portal = {
            enable = true;
            config = {
              common = {
                default = [ "gtk" ];
                "org.freedesktop.impl.portal.Secret" =
                  if config.services.gnome-keyring.enable then "gnome-keyring" else "none";
                "org.freedesktop.impl.portal.Inhibit" = "none";
              };
            };
            extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
          };
          terminal-exec = {
            enable = true;
            package = pkgs.xdg-terminal-exec;
          };
          userDirs = {
            enable = true;
            package = pkgs.xdg-user-dirs;
            createDirectories = true;
            setSessionVariables = false;
            desktop = "${homeDir}";
            projects = "${homeDir}/src";
            download = "${homeDir}/dls";
            documents = "${homeDir}/docs";
            publicShare = "${homeDir}/docs/share";
            templates = "${homeDir}/docs/templates";
            music = "${homeDir}/docs/music";
            videos = "${homeDir}/docs/vids";
            pictures = "${homeDir}/docs/pics";
          };
          mimeApps = {
            enable = true;
          };
        };

        home = {
          preferXdgDirectories = config.xdg.enable;
          shellAliases = lib.mkIf config.xdg.enable {
            open = "xdg-open";
          };
        };

        # TODO: select window
        xdg.configFile."xdg-desktop-portal-wlr/config" =
          let
            iniFormat = pkgs.formats.ini { };
          in
          lib.mkIf config.xdg.portal.enable {
            source = iniFormat.generate "xdg-desktop-portal-wlr-config.ini" {
              screencast = {
                max_fps = 60;
                chooser_type = "simple";
                chooser_cmd = "${pkgs.slurp}/bin/slurp -or -f 'Monitor: %o'";
              };
            };
          };
      };

  };
}
