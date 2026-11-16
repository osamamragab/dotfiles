{
  inputs,
  lib,
  config,
  ...
}: let
  mkHost = hostAttrs: let
    hasBase = hostAttrs.aspects |> lib.any (a: a.name == "base");
    base = lib.optional (!hasBase) config.flake.aspects.base;
    aspects = base ++ hostAttrs.aspects;
  in
    hostAttrs
    // {
      inherit aspects;
      nixosModules = aspects |> lib.map (a: a.nixos or {});
      homeModules = aspects |> lib.map (a: a.homeManager or {});
      knownHosts =
        config.flake.hosts
        |> lib.filterAttrs (hn: h: hn != hostAttrs.name && h.sshKey != "")
        |> lib.mapAttrs' (
          hn: h:
            lib.nameValuePair hn {
              hostNames = [hn];
              publicKey = h.sshKey;
            }
        );
    };
in {
  config.flake.modules = lib.genAttrs ["nixos" "homeManager"] (
    class: config.flake.aspects |> lib.mapAttrs (_: aspect: aspect.${class})
  );

  config.flake.nixosConfigurations =
    config.flake.hosts
    |> lib.mapAttrs (
      _: hostAttrs: let
        host = mkHost hostAttrs;
      in
        inputs.nixpkgs.lib.nixosSystem {
          system = host.system;
          specialArgs = {inherit inputs host;};
          modules = [host.module] ++ host.nixosModules ++ host.extraModules;
        }
    );

  config.flake.homeConfigurations =
    config.flake.hosts
    |> lib.mapAttrs' (
      _: hostAttrs: let
        host = mkHost hostAttrs;
      in
        lib.nameValuePair "${host.user}@${host.name}" (
          inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = import inputs.nixpkgs {inherit (host) system;};
            extraSpecialArgs = {inherit inputs host;};
            modules = host.homeModules ++ host.extraHomeModules;
          }
        )
    );
}
