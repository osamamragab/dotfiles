{
    pkgs,
    lib,
    config,
    ...
}:
{
    xdg = {
        enable = true;
        localBinInPath = true;
        configHome = "${config.home.homeDirectory}/.config";
        cacheHome = "${config.home.homeDirectory}/.cache";
        dataHome = "${config.home.homeDirectory}/.local/share";
        stateHome = "${config.home.homeDirectory}/.local/state";
        binHome = "${config.home.homeDirectory}/.local/bin";
        portal = {
            enable = true;
            config = {
                common = {
                    default = [ "gtk" ];
                    "org.freedesktop.impl.portal.Secret" =
                        if config.services.gnome-keyring.enable then "gnome-keyring" else "none";
                    "org.freedesktop.impl.portal.Inhibit" = "none";
                };
                mango = lib.mkIf config.wayland.windowManager.mango.enable {
                    "org.freedesktop.impl.portal.ScreenCast" = "wlr";
                    "org.freedesktop.impl.portal.Screenshot" = "wlr";
                };
            };
            extraPortals = with pkgs; [
                xdg-desktop-portal-wlr
                xdg-desktop-portal-gtk
            ];
        };
        terminal-exec = {
            enable = true;
            package = pkgs.xdg-terminal-exec;
            settings = {
                default = [ "foot.desktop" ];
            };
        };
        userDirs = {
            enable = true;
            package = pkgs.xdg-user-dirs;
            createDirectories = true;
            setSessionVariables = false;
            desktop = "${config.home.homeDirectory}";
            projects = "${config.home.homeDirectory}/src";
            download = "${config.home.homeDirectory}/dls";
            documents = "${config.home.homeDirectory}/docs";
            publicShare = "${config.home.homeDirectory}/docs/share";
            templates = "${config.home.homeDirectory}/docs/templates";
            music = "${config.home.homeDirectory}/docs/music";
            videos = "${config.home.homeDirectory}/docs/vids";
            pictures = "${config.home.homeDirectory}/docs/pics";
        };
        mimeApps = {
            enable = true;
            defaultApplications = {
                # TODO
            };
        };
    };

    home.sessionPath = lib.mkIf config.xdg.localBinInPath [ config.xdg.binHome ];

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
}
