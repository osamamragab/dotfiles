{
  den.aspects.virtualisation = {
    nixos = {
      lib,
      host,
      ...
    }: {
      users.groups.kvm.members = host.users |> lib.mapAttrsToList (_: u: u.userName);
    };
  };
}
