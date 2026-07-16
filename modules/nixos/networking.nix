{
    pkgs,
    ...
}:
{
    networking = {
        networkmanager = {
            enable = true;
            package = pkgs.networkmanager;
        };
        wireless.enableHardening = true;
        firewall = {
            enable = true;
            logRefusedConnections = true;
            logRefusedPackets = false;
            rejectPackets = false; # drop packets instead of rejecting them
        };
    };
}
