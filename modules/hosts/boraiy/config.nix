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
    module = {pkgs, ...}: {
      boot.kernelPackages = pkgs.linuxPackages_zen;

      networking.wireless.enable = true;
      services.openssh.openFirewall = true;

      services.logind.settings.Login = {
        HandlePowerKey = "lock";
        HandleLidSwitch = "lock";
        HandleLidSwitchDocked = "lock";
        HandleLidSwitchExternalPower = "lock";
      };
    };
    homeModule = {
      programs.noctalia.settings.idle.behavior.suspend.enabled = false;
    };
  };
}
