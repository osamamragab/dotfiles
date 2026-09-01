{
  flake.aspects.base = {
    nixos = {
      services.logind = {
        enable = true;
        settings = {
          Login = {
            HandlePowerKey = "ignore";
            HandleLidSwitchDocked = "ignore";
          };
        };
      };
    };
  };
}
