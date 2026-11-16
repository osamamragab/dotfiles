{
  inputs,
  lib,
  config,
  ...
}: let
  mkHost = hostName: hostAttrs: let
    hasBase = hostAttrs.aspects |> lib.any (a: a == config.flake.aspects.base);
    base = lib.optional (!hasBase) config.flake.aspects.base;
    aspects = base ++ hostAttrs.aspects;
  in
    hostAttrs
    // {
      inherit hostName aspects;
      nixosModules = aspects |> lib.map (a: a.nixos or {});
      homeModules = aspects |> lib.map (a: a.homeManager or {});
      knownHosts =
        config.flake.hosts
        |> lib.filterAttrs (hn: h: hn != hostName && h.sshKey != "")
        |> lib.mapAttrs' (
          hn: h:
            lib.nameValuePair hn {
              hostNames = [hn];
              publicKey = h.sshKey;
            }
        );
    };
in {
  options.flake.aspects = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          nixos = lib.mkOption {
            type = lib.types.deferredModule;
            default = {};
          };
          homeManager = lib.mkOption {
            type = lib.types.deferredModule;
            default = {};
          };
        };
      }
    );
    default = {};
  };

  options.flake.hosts = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          system = lib.mkOption {
            type = lib.types.str;
          };
          user = lib.mkOption {
            type = lib.types.str;
          };
          sshKey = lib.mkOption {
            type = lib.types.str;
            default = "";
          };
          stateVersion = lib.mkOption {
            type = lib.types.str;
            default = "26.11";
          };
          aspects = lib.mkOption {
            type = lib.types.listOf lib.types.attrs;
            default = [];
          };
          module = lib.mkOption {
            type = lib.types.deferredModule;
            default = {};
          };
          extraModules = lib.mkOption {
            type = lib.types.listOf lib.types.deferredModule;
            default = [];
          };
          extraHomeModules = lib.mkOption {
            type = lib.types.listOf lib.types.deferredModule;
            default = [];
          };
        };
      }
    );
    default = {};
  };

  config.flake.modules = lib.genAttrs ["nixos" "homeManager"] (
    class: config.flake.aspects |> lib.mapAttrs (_: aspect: aspect.${class})
  );

  config.flake.nixosConfigurations =
    config.flake.hosts
    |> lib.mapAttrs (
      hostName: hostAttrs: let
        host = mkHost hostName hostAttrs;
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
      hostName: hostAttrs: let
        host = mkHost hostName hostAttrs;
      in
        lib.nameValuePair "${host.user}@${host.hostName}" (
          inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = import inputs.nixpkgs {inherit (host) system;};
            extraSpecialArgs = {inherit inputs host;};
            modules = host.homeModules ++ host.extraHomeModules;
          }
        )
    );
}
