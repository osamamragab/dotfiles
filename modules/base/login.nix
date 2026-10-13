{
  flake.aspects.base = {
    nixos = { lib, ... }: {
      services.logind = {
        enable = true;
        settings = {
          Login = {
            HandlePowerKey = lib.mkDefault "ignore";
            HandleLidSwitchDocked = lib.mkDefault "ignore";
          };
        };
      };
    };
  };
}
