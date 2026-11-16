{
  flake-file.inputs.home-manager.url = "github:nix-community/home-manager";

  flake.aspects.base = {
    nixos = {
      inputs,
      pkgs,
      lib,
      host,
      ...
    }: {
      imports = [inputs.home-manager.nixosModules.home-manager];

      users = {
        defaultUserShell = lib.mkDefault pkgs.bashInteractive;
        users.${host.user} = {
          name = lib.mkDefault host.user;
          group = host.user;
          isNormalUser = lib.mkDefault true;
          useDefaultShell = lib.mkDefault true;
          extraGroups = ["wheel"];
        };
        groups.${host.user} = {};
      };

      home-manager = {
        useGlobalPkgs = lib.mkDefault true;
        useUserPackages = lib.mkDefault true;
        extraSpecialArgs = {inherit inputs host;};
        users.${host.user}.imports = host.homeModules ++ host.extraHomeModules;
      };
    };

    homeManager = {
      lib,
      host,
      ...
    }: {
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
