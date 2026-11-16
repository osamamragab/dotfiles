{lib, ...}: {
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
}
