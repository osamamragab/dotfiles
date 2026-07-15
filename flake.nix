{
    description = "root NixOS flake";
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
        mangowm = {
            url = "github:mangowm/mango";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        arkenfox = {
            url = "github:dwarfmaster/arkenfox-nixos";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs =
        {
            self,
            nixpkgs,
            nur,
            home-manager,
            disko,
            ...
        }@inputs:
        let
            utils = import ./lib/utils.nix { lib = nixpkgs.lib; };
            mkSystem =
                { host, user }:
                nixpkgs.lib.nixosSystem {
                    specialArgs = {
                        inherit inputs;
                        custom = {
                            inherit utils;
                            systemInfo = {
                                inherit host user;
                                stateVersion = "26.11";
                            };
                        };
                    };
                    modules = [
                        nur.modules.nixos.default
                        home-manager.nixosModules.home-manager
                        disko.nixosModules.disko
                        ./modules/nixos
                        ./hosts/${host}
                    ];
                };
        in
        {
            nixosConfigurations = {
                xlab = mkSystem {
                    host = "xlab";
                    user = "osama";
                };
            };
        };
}
