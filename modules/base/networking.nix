{
  flake.aspects.base = {
    nixos =
      {
        pkgs,
        lib,
        config,
        host,
        ...
      }:
      {
        networking = {
          networkmanager = {
            enable = true;
            package = pkgs.networkmanager;
          };
          wireless = {
            enableHardening = true;
            scanOnLowSignal = true;
          };
          firewall = {
            enable = true;
            logRefusedConnections = true;
            logRefusedPackets = false;
            rejectPackets = false; # drop packets instead of rejecting them
          };
        };

        users.groups.networkmanager.members = [ host.user ];

        services.vnstat = {
          enable = true;
          package = pkgs.vnstat;
        };
      };

    homeManager = { pkgs, ... }: {
      home = {
        packages = with pkgs; [
          inetutils
          mitmproxy
          bettercap
          wireshark
          termshark
          netcat-openbsd
          macchanger
          nmap
          aircrack-ng
          proxychains-ng
          dnsproxy
          mosh
          wrk
          tor
          torsocks
          transmission_4
        ];
        shellAliases = {
          mitmproxy = ''mitmproxy --set confdir="$XDG_CONFIG_HOME/mitmproxy"'';
          mitmweb = ''mitmweb --set confdir="$XDG_CONFIG_HOME/mitmproxy"'';
        };
      };
    };
  };
}
