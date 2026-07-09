{ pkgs, lib, config, ... }:
{
    home.packages = [ pkgs.keyd ];

    xdg.configFile."keyd/app.conf".text = ''
        [firefox]
        control.y = C-c
        control.p = C-v

        [org-mozilla-firefox]
        control.y = C-c
        control.p = C-v

        [chromium]
        control.y = C-c
        control.p = C-v

        [org-chromium-chromium]
        control.y = C-c
        control.p = C-v
    '';

    wayland.windowManager.mango.settings.exec-once =
        lib.mkIf config.wayland.windowManager.mango.enable
        [
            "${pkgs.keyd}/bin/keyd-application-mapper"
        ];
}
