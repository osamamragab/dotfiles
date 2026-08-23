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
            home.packages = with pkgs; [
                mitmproxy
                bettercap
                wireshark
                termshark
                aircrack-ng
                proxychains-ng
                netcat-openbsd
                macchanger
                mosh
                wrk
                tor
                torsocks
                transmission_4
            ];
        };
    };
}
