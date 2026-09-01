{
  flake.aspects.base = {
    nixos = { pkgs, config, ... }: {
      security = {
        apparmor = {
          enable = true;
          killUnconfinedConfinables = true;
        };
        audit = {
          enable = true;
          package = pkgs.audit;
        };
        auditd = {
          enable = true;
          package = config.security.audit.package;
        };
        polkit = {
          enable = true;
          package = pkgs.polkit;
        };
      };
    };
  };
}
