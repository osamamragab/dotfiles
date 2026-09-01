{
  flake.aspects.virtualisation = {
    nixos = { host, ... }: {
      users.groups.kvm.members = [ host.user ];
    };
  };
}
