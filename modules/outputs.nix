{
  inputs,
  lib,
  config,
  ...
}: {
  options.flake.aspects = lib.mkOption {
    default = {};
    type = lib.types.attrsOf (
      lib.types.submodule ({name, ...}: {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            default = name;
            readOnly = true;
          };
          nixos = lib.mkOption {
            type = lib.types.deferredModule;
            default = {};
          };
          homeManager = lib.mkOption {
            type = lib.types.deferredModule;
            default = {};
          };
        };
      })
    );
  };

  options.flake.hosts = lib.mkOption {
    default = {};
    type = let
      flakeModules = config.flake.modules;
    in
      lib.types.attrsOf (
        lib.types.submodule ({
          name,
          config,
          ...
        }: {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              default = name;
              readOnly = true;
            };
            system = lib.mkOption {
              type = lib.types.str;
            };
            stateVersion = lib.mkOption {
              type = lib.types.str;
              default = "26.11";
            };
            user = lib.mkOption {
              type = lib.types.str;
            };
            sshKey = lib.mkOption {
              type = lib.types.str;
              default = "";
            };
            aspects = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [];
            };
            module = lib.mkOption {
              type = lib.types.deferredModule;
              default = {};
            };
            homeModule = lib.mkOption {
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
            resolvedAspects = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              readOnly = true;
              default = lib.unique (["base"] ++ config.aspects);
            };
            resolvedModules = lib.mkOption {
              type = lib.types.listOf lib.types.deferredModule;
              readOnly = true;
              default =
                [config.module]
                ++ config.extraModules
                ++ (config.resolvedAspects |> lib.map (a: flakeModules.nixos.${a} or {}));
            };
            resolvedHomeModules = lib.mkOption {
              type = lib.types.listOf lib.types.deferredModule;
              readOnly = true;
              default =
                [config.homeModule]
                ++ config.extraHomeModules
                ++ (config.resolvedAspects |> lib.map (a: flakeModules.homeManager.${a} or {}));
            };
          };
        })
      );
  };

  config.flake.modules = lib.genAttrs ["nixos" "homeManager"] (
    class: config.flake.aspects |> lib.mapAttrs (_: aspect: aspect.${class})
  );

  config.flake.nixosConfigurations =
    config.flake.hosts
    |> lib.mapAttrs (
      _: host:
        inputs.nixpkgs.lib.nixosSystem {
          system = host.system;
          specialArgs = {inherit inputs host;};
          modules = host.resolvedModules;
        }
    );

  config.flake.homeConfigurations =
    config.flake.hosts
    |> lib.mapAttrs' (
      _: host:
        lib.nameValuePair "${host.user}@${host.name}" (
          inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = import inputs.nixpkgs {inherit (host) system;};
            extraSpecialArgs = {inherit inputs host;};
            modules = host.resolvedHomeModules;
          }
        )
    );
}
