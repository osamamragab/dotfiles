{
  flake-file.inputs.home-manager.url = "github:nix-community/home-manager";

  flake.aspects.base = {
    nixos = {
      inputs,
      pkgs,
      lib,
      config,
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
          hashedPasswordFile = config.sops.secrets."${host.user}_password".path;
        };
        groups.${host.user} = {};
      };

      home-manager = {
        useGlobalPkgs = lib.mkDefault true;
        useUserPackages = lib.mkDefault true;
        extraSpecialArgs = {inherit inputs host;};
        users.${host.user}.imports = host.resolvedHomeModules;
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
