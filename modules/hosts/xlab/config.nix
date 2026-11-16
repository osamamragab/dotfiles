{config, ...}: {
  flake.hosts.xlab = {
    system = "x86_64-linux";
    user = "osama";
    sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILIgsbWIOfq9autOqHLrP8PCoTrAOG50BPDSbWjoCQzC";
    aspects = with config.flake.aspects; [
      shell
      tools
      desktop
      dev
      virtualisation
    ];
    module = {
      pkgs,
      lib,
      config,
      ...
    }: {
      networking.wireless.enable = true;
      boot = {
        kernelPackages = pkgs.linuxPackages_zen;
        plymouth.enable = true;
      };
    };
  };
}
