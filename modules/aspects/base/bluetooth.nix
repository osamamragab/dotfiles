{
  den.aspects.base = {
    nixos = {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            ControllerMode = "bredr";
            Experimental = true;
            FastConnectable = true;
            ClassicBondedOnly = true;
          };
          Policy = {
            AutoEnable = true;
          };
        };
      };
    };

    homeManager = {
      services.mpris-proxy.enable = true;
    };
  };
}
