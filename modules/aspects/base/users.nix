{
  den.aspects.base = {
    nixos = {
      pkgs,
      lib,
      host,
      config,
      ...
    }: let
      userNames = host.users |> lib.mapAttrsToList (_: u: u.userName);
    in {
      users = {
        defaultUserShell = lib.mkDefault pkgs.bashInteractive;
        users = lib.genAttrs userNames (name: {
          name = lib.mkDefault name;
          group = name;
          isNormalUser = lib.mkDefault true;
          useDefaultShell = lib.mkDefault true;
          extraGroups = ["wheel"];
          hashedPasswordFile = config.sops.secrets."users_${name}_password".path;
        });
        groups = lib.genAttrs userNames (_: {});
      };
    };
  };
}
