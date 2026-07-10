{ pkgs, lib, config, ... }:
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
            extraPortals = with pkgs; [
                xdg-desktop-portal-wlr
                xdg-desktop-portal-gtk
            ];
            config = {
                common = {
                    default = [ "gtk" ];
                    "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
                    "org.freedesktop.impl.portal.Inhibit" = "none";
                };
                mango = lib.mkIf config.wayland.windowManager.mango.enable {
                    "org.freedesktop.impl.portal.ScreenCast" = "wlr";
                    "org.freedesktop.impl.portal.Screenshot" = "wlr";
                };
            };
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
}
