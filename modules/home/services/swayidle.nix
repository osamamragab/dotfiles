{ pkgs, ... }:
let
    swaylock = "${pkgs.swaylock}/bin/swaylock -fF";
    systemctl = "${pkgs.systemd}/bin/systemctl";
    makoctl = "${pkgs.mako}/bin/makoctl";
    wlr-randr = "${pkgs.wlr-randr}/bin/wlr-randr";
    brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
in
{
    services.swayidle = {
        enable = true;
        package = pkgs.swayidle;
        events = {
            lock = swaylock;
            before-sleep = swaylock;
        };
        timeouts = [
            {
                timeout = 180;
                command = "${makoctl} mode -a away >/dev/null 2>&1; ${brightnessctl} -q -s -c backlight set 20%";
                resumeCommand = "${makoctl} mode -r away >/dev/null 2>&1; ${brightnessctl} -q -r";
            }
            {
                timeout = 300;
                command = swaylock;
            }
            {
                timeout = 330;
                command = "${wlr-randr} --output '*' --off";
                resumeCommand = "${wlr-randr} --output '*' --on";
            }
            {
                timeout = 1200;
                command = "${systemctl} suspend";
            }
        ];
    };
}
