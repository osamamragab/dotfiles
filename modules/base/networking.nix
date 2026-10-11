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
          nftables.enable = true;
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
            trustedInterfaces = lib.optional config.services.tailscale.enable config.services.tailscale.interfaceName;
            allowedUDPPorts = lib.optional config.services.tailscale.enable config.services.tailscale.port;
          };
        };

        systemd.network.wait-online.enable = config.boot.initrd.systemd.enable;

        users.groups.networkmanager.members = [ host.user ];

        services.vnstat = {
          enable = true;
          package = pkgs.vnstat;
        };

        services.tailscale = {
          enable = true;
          package = pkgs.tailscale;
        };
        systemd.services.tailscaled.serviceConfig.Environment = lib.optional (
          config.services.tailscale.enable && config.networking.nftables.enable
        ) "TS_DEBUG_FIREWALL_MODE=nftables";
      };

    homeManager = { pkgs, ... }: {
      home = {
        packages = with pkgs; [
          dnsutils
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
