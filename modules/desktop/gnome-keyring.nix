{
  flake.aspects.desktop = {
    nixos = {
      services.gnome.gnome-keyring.enable = true;
    };

    homeManager = { pkgs, ... }: {
      services.gnome-keyring = {
        enable = true;
        package = pkgs.gnome-keyring;
        components = [ ];
      };
    };
  };
}
