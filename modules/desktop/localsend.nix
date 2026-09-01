{
  flake.aspects.desktop = {
    nixos = {
      networking.firewall = {
        allowedTCPPorts = [
          53317 # LocalSend TCP transfer
        ];
        allowedUDPPorts = [
          53317 # LocalSend UDP discovery
        ];
      };
    };

    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        localsend
      ];
    };
  };
}
