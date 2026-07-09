{ pkgs, ... }:
{
    services.syncthing = {
        enable = true;
        package = pkgs.syncthing;
        guiAddress = "127.0.0.1:8384";
        settings = {
            options = {
                urAccepted = -1;
                natEnabled = false;
                startBrowser = false;
                relaysEnabled = false;
                limitBandwidthInLan = false;
                localAnnounceEnabled = true;
                globalAnnounceEnabled = false;
                crashReportingEnabled = false;
            };
        };
        tray = {
            enable = true;
            package = pkgs.syncthingtray-minimal;
            command = "syncthingtray --wait";
        };
    };
}
