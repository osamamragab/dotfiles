{
  flake.hosts.boraiy = {
    system = "x86_64-linux";
    user = "x";
    aspects = [
      "shell"
      "tools"
      "desktop"
      "virtualisation"
    ];
    module = {
      pkgs,
      host,
      ...
    }: {
      boot = {
        plymouth.enable = false;
        kernelPackages = pkgs.linuxPackages_zen;
      };

      networking.wireless.enable = true;

      services.logind.settings.Login = {
        HandlePowerKey = "lock";
        HandleLidSwitch = "lock";
        HandleLidSwitchDocked = "lock";
        HandleLidSwitchExternalPower = "lock";
      };

      services.openssh = {
        enable = true;
        openFirewall = true;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "no";
          AllowUsers = [host.user];
          MaxAuthTries = 3;
          PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
        };
      };
    };
    homeModule = {
      programs.noctalia.settings.idle.behavior.suspend.enabled = false;
    };
  };
}
