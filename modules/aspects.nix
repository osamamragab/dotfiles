{
  inputs,
  lib,
  config,
  ...
}:
let
  getAspects =
    aspects:
    aspects
    |> lib.map (
      aspect:
      if lib.isAttrs aspect then
        aspect
      else if lib.isString aspect then
        config.flake.aspects.${aspect} or (lib.throw "Aspect '${aspect}' not found")
      else
        lib.throw "Invalid aspect reference: ${lib.toString aspect}"
    );
  getAspectsForClass =
    class: aspects:
    aspects
    |> lib.map (aspect: aspect.${class} or null)
    |> lib.filter (aspect: aspect != null);
in
{
  options.flake.aspects = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          nixos = lib.mkOption {
            type = lib.types.deferredModule;
            default = { };
          };
          homeManager = lib.mkOption {
            type = lib.types.deferredModule;
            default = { };
          };
          darwin = lib.mkOption {
            type = lib.types.deferredModule;
            default = { };
          };
        };
      }
    );
    default = { };
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
          stateVersion = lib.mkOption {
            type = lib.types.str;
            default = "26.11";
          };
          aspects = lib.mkOption {
            type = lib.types.listOf (lib.types.either lib.types.str lib.types.attrs);
            default = [ ];
          };
          module = lib.mkOption {
            type = lib.types.deferredModule;
            default = { };
          };
          extraModules = lib.mkOption {
            type = lib.types.listOf lib.types.deferredModule;
            default = [ ];
          };
          extraHomeModules = lib.mkOption {
            type = lib.types.listOf lib.types.deferredModule;
            default = [ ];
          };
          extraDarwinModules = lib.mkOption {
            type = lib.types.listOf lib.types.deferredModule;
            default = [ ];
          };
        };
      }
    );
    default = { };
  };

  config.flake.modules = lib.genAttrs [ "nixos" "homeManager" "darwin" ] (
    class: config.flake.aspects |> lib.mapAttrs (_: aspect: aspect.${class})
  );

  config.flake.nixosConfigurations =
    config.flake.hosts
    |> lib.mapAttrs (
      hostName: host:
      let
        aspects = getAspects host.aspects;
        nixosModules = aspects |> getAspectsForClass "nixos";
        hmModules = aspects |> getAspectsForClass "homeManager";
      in
      inputs.nixpkgs.lib.nixosSystem {
        system = host.system;
        specialArgs = { inherit inputs host; };
        modules = [
          inputs.nur.modules.nixos.default
          inputs.disko.nixosModules.disko
          inputs.home-manager.nixosModules.home-manager
        ]
        ++ nixosModules
        ++ [ host.module ]
        ++ host.extraModules
        ++ [
          {
            networking.hostName = hostName;
            system.stateVersion = host.stateVersion;
            users.users.${host.user} = { };
            home-manager = {
              extraSpecialArgs = { inherit inputs host; };
              users.${host.user} = (hmModules ++ host.extraHomeModules) |> lib.mkMerge;
            };
          }
        ];
      }
    );

  config.flake.homeConfigurations =
    config.flake.hosts
    |> lib.mapAttrs (
      _: host:
      let
        hmModules = getAspects host.aspects |> getAspectsForClass "homeManager";
      in
      inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${host.system};
        extraSpecialArgs = { inherit inputs host; };
        modules = [
          inputs.nur.modules.homeManager.default
        ]
        ++ hmModules
        ++ host.extraHomeModules;
      }
    );
}
