{lib, ...}: {
  options.flake.hosts = lib.mkOption {
    default = {};
    type = lib.types.attrsOf (
      lib.types.submodule ({name, ...}: {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            default = name;
            readOnly = true;
          };
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
      })
    );
  };
}
