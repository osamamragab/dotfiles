{inputs, ...}: let
  nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operators"
    ];
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://noctalia.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };
in {
  flake-file.nixConfig =
    nixConfig
    // {
      abort-on-warn = true;
      allow-import-from-derivation = false;
    };

  flake-file.inputs.nur.url = "github:nix-community/NUR";

  den.aspects.base = {
    nixos = {lib, ...}: {
      imports = [inputs.nur.modules.nixos.default];

      system.stateVersion = lib.mkDefault "26.11";

      nix = {
        checkConfig = true;
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
        };
        settings =
          nixConfig
          // {
            trusted-users = [
              "root"
              "@wheel"
            ];
            use-xdg-base-directories = true;
            cores = 0; # use all cores
            max-jobs = "auto";
            sandbox = true;
            http-connections = 25;
            auto-optimise-store = true;
            substitute = true;
            max-substitution-jobs = 16;
            keep-outputs = true;
            keep-derivations = true;
          };
      };

      programs.nix-ld.enable = true;
      programs.nix-index.enable = true;

      home-manager = {
        useGlobalPkgs = lib.mkDefault true;
        useUserPackages = lib.mkDefault true;
      };
    };

    homeManager = {lib, ...}: {
      home.stateVersion = lib.mkDefault "26.11";
    };
  };
}
