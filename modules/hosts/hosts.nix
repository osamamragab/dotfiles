{
  inputs,
  lib,
  config,
  ...
}: {
  options.flake.hosts = lib.mkOption {
    default = {};
    type = let
      flakeHosts = config.flake.hosts;
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
              default = let
                hasBase = config.aspects |> lib.any (a: a == "base");
                base = lib.optional (!hasBase) "base";
              in
                base ++ config.aspects;
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
            resolvedKnownHosts = lib.mkOption {
              type = lib.types.attrsOf (lib.types.submodule {
                options = {
                  hostNames = lib.mkOption {type = lib.types.listOf lib.types.str;};
                  publicKey = lib.mkOption {type = lib.types.str;};
                };
              });
              readOnly = true;
              default =
                flakeHosts
                |> lib.filterAttrs (hn: h: hn != name && h.sshKey != "")
                |> lib.mapAttrs' (hn: h:
                  lib.nameValuePair hn {
                    hostNames = [hn];
                    publicKey = h.sshKey;
                  });
            };
          };
        })
      );
  };

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
