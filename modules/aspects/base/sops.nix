{inputs, ...}: {
  flake-file.inputs.sops-nix.url = "github:Mic92/sops-nix";

  den.aspects.base = {
    nixos = {
      pkgs,
      lib,
      host,
      ...
    }: let
      secretsDir = ../../../secrets;
    in {
      imports = [inputs.sops-nix.nixosModules.sops];

      sops = {
        defaultSopsFile = "${secretsDir}/${host.name}.yaml";
        secrets =
          host.users
          |> lib.mapAttrs' (_: u:
            lib.nameValuePair "users_${u.userName}_password" {
              key = "users/${u.userName}/password";
              neededForUsers = true;
            });
      };

      environment.systemPackages = [
        pkgs.age
        pkgs.sops
        pkgs.ssh-to-age
      ];
    };
    homeManager = {pkgs, ...}: {
      imports = [inputs.sops-nix.homeManagerModules.sops];

      home.packages = with pkgs; [
        age
        sops
      ];
    };
  };
}
