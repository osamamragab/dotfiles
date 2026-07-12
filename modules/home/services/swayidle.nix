{ pkgs, config, ... }:
let
    makoctlBin = "${config.programs.mako.package or pkgs.mako}/bin/makoctl";
    swaylockBin = "${config.programs.swaylock.package or pkgs.swaylock}/bin/swaylock -fF";
in
{
    services.swayidle = {
        enable = true;
        package = pkgs.swayidle;
        events = {
            lock = swaylockBin;
            before-sleep = swaylockBin;
        };
        timeouts = [
            {
                timeout = 5 * 60;
                command = "${makoctlBin} mode -a away >/dev/null 2>&1; ${pkgs.brightnessctl}/bin/brightnessctl -q -s -c backlight set 20%";
                resumeCommand = "${makoctlBin} mode -r away >/dev/null 2>&1; ${pkgs.brightnessctl}/bin/brightnessctl -q -r";
            }
            {
                timeout = 10 * 60;
                command = swaylockBin;
            }
            {
                timeout = 15 * 60;
                command = "${pkgs.wlopm}/bin/wlopm --off '*'";
                resumeCommand = "${pkgs.wlopm}/bin/wlopm --on '*'";
            }
            {
                timeout = 20 * 60;
                command = "${pkgs.systemd}/bin/systemctl -i suspend";
            }
        ];
    };
}
