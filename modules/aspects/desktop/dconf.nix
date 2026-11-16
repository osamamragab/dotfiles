{
  flake.aspects.desktop = {
    nixos = {
      programs.dconf.enable = true;
    };
  };
}
