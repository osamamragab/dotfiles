{
    description = "Osama's NixOS configuration";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        flake-parts.url = "github:hercules-ci/flake-parts";
        import-tree.url = "github:denful/import-tree";
        flake-aspects.url = "github:denful/flake-aspects";
        nur = {
            url = "github:nix-community/NUR";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        disko = {
            url = "github:nix-community/disko";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        stylix = {
            url = "github:nix-community/stylix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        mangowm = {
            url = "github:mangowm/mango";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        noctalia = {
            url = "github:noctalia-dev/noctalia/cachix";
            #inputs.nixpkgs.follows = "nixpkgs";
        };
        noctalia-greeter = {
            url = "github:noctalia-dev/noctalia-greeter";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        arkenfox = {
            url = "github:dwarfmaster/arkenfox-nixos";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

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

    outputs =
        inputs:
        inputs.flake-parts.lib.mkFlake { inherit inputs; } (
            inputs.import-tree ./modules
        );
}
