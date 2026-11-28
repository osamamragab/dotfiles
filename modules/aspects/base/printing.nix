{
  den.aspects.base = {
    nixos = {
      pkgs,
      lib,
      config,
      host,
      ...
    }: let
      cfg = config.services.printing;
      userNames = host.users |> lib.mapAttrsToList (_: u: u.userName);
    in {
      services.printing = {
        enable = true;
        drivers = with pkgs; [
          gutenprint
          hplip
          splix
        ];
      };

      users.groups.lp.members = lib.optionals cfg.enable userNames;
      users.groups.lpadmin.members = lib.optionals cfg.enable userNames;
    };
  };
}
