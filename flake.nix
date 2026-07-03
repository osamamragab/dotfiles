{
	description = "root NixOS flake";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
	};

	outputs = { self, nixpkgs, home-manager, disko, mangowm, ... }@inputs:
		let
			mkSystem = { host, user, system ? "x86_64-linux" }: nixpkgs.lib.nixosSystem {
				system = system;
				specialArgs = {
					inherit inputs;
					systemInfo = {
						inherit host user system;
						stateVersion = "26.11";
					};
				};
				modules = [
					disko.nixosModules.disko
					home-manager.nixosModules.home-manager
					mangowm.nixosModules.mango
					./modules/nixos
					./modules/hosts/${host}
				];
			};
		in
		{
			nixosConfigurations = {
				xlab = mkSystem { host = "xlab"; user = "osama"; };
			};
		};
}
