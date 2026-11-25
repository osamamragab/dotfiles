{
  flake-file.inputs.sops-nix.url = "github:Mic92/sops-nix";

  flake.aspects.base = {
    nixos = {
      inputs,
      pkgs,
      host,
      ...
    }: let
      secretsDir = ../../../secrets;
    in {
      imports = [inputs.sops-nix.nixosModules.sops];

      sops = {
        defaultSopsFile = "${secretsDir}/${host.name}.yaml";
        secrets = {
          "${host.user}_password" = {
            key = "users/${host.user}/password";
            neededForUsers = true;
          };
        };
      };

      environment.systemPackages = [
        pkgs.age
        pkgs.sops
        pkgs.ssh-to-age
      ];
    };
    homeManager = {
      inputs,
      pkgs,
      ...
    }: {
      imports = [inputs.sops-nix.homeManagerModules.sops];

      home.packages = with pkgs; [
        age
        sops
      ];
    };
  };
}
