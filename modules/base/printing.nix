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
      let
        cfg = config.services.printing;
      in
      {
        services.printing = {
          enable = true;
          package = pkgs.cups;
          drivers = with pkgs; [
            gutenprint
            hplip
            splix
          ];
        };

        users.groups.lp.members = lib.optional cfg.enable host.user;
        users.groups.lpadmin.members = lib.optional cfg.enable host.user;
      };
  };
}
