{
  den.aspects.dev = {
    nixos = {
      lib,
      config,
      host,
      ...
    }: {
      hardware.i2c = {
        enable = true;
        group = "i2c";
      };

      users.groups.i2c.members =
        host.users
        |> lib.mapAttrsToList (_: u: u.userName)
        |> lib.optionals config.hardware.i2c.enable;
    };
  };
}
