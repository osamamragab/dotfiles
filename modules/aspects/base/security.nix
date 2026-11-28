{
  den.aspects.base = {
    nixos = {
      security = {
        audit.enable = true;
        auditd.enable = true;
        polkit.enable = true;
        apparmor = {
          enable = true;
          killUnconfinedConfinables = true;
        };
      };
    };
  };
}
