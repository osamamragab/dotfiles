{
  den.aspects.tools = {
    nixos = {
      networking.firewall = {
        allowedTCPPorts = [
          22000 # Syncthing TCP sync
        ];
        allowedUDPPorts = [
          22000 # Syncthing QUIC sync
          21027 # Syncthing discovery
        ];
      };
    };

    homeManager = {
      services.syncthing = {
        enable = true;
        guiAddress = "127.0.0.1:8384";
        overrideDevices = false;
        overrideFolders = false;
        settings.options = {
          urAccepted = -1;
          natEnabled = false;
          startBrowser = false;
          relaysEnabled = false;
          limitBandwidthInLan = false;
          localAnnounceEnabled = true;
          globalAnnounceEnabled = false;
          crashReportingEnabled = false;
        };
        tray = {
          enable = true;
          command = "syncthingtray --wait";
        };
      };
    };
  };
}
