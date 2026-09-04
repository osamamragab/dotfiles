{
  flake-file.inputs.home-manager.url = "github:nix-community/home-manager";

  flake.aspects.base = {
    nixos =
      {
        pkgs,
        lib,
        host,
        ...
      }:
      {
        users = {
          defaultUserShell = lib.mkDefault pkgs.bashInteractive;
          users.${host.user} = {
            name = lib.mkDefault host.user;
            group = host.user;
            isNormalUser = lib.mkDefault true;
            useDefaultShell = lib.mkDefault true;
            extraGroups = [ "wheel" ];
          };
          groups.${host.user} = { };
        };

        home-manager = {
          useGlobalPkgs = lib.mkDefault true;
          useUserPackages = lib.mkDefault true;
        };
      };

    homeManager = { lib, host, ... }: {
      programs.home-manager.enable = true;

      home = {
        username = host.user;
        stateVersion = host.stateVersion;
        homeDirectory = "/home/${host.user}";
        enableNixpkgsReleaseCheck = lib.mkDefault true;
      };
    };
  };
}
