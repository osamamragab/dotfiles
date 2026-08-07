{
    pkgs,
    lib,
    config,
    ...
}:
{
    home.packages = [
        pkgs.keyd
    ];

    xdg.configFile."keyd/app.conf".source =
        let
            iniFormat = pkgs.formats.ini { };
            common = {
                "control.y" = "C-c";
                "control.p" = "C-v";
            };
        in
        iniFormat.generate "app.conf" {
            firefox = common;
            org-mozilla-firefox = common;
            chromium = common;
            org-chromium-chromium = common;
        };

    wayland.windowManager.mango.settings.exec-once =
        lib.mkIf config.wayland.windowManager.mango.enable
            [
                "${pkgs.keyd}/bin/keyd-application-mapper"
            ];
}
