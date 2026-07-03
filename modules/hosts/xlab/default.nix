{ inputs, pkgs, lib, config, systemInfo, ... }:
{
	imports = [
		./boot.nix
		./shell.nix
		./desktop.nix
		./services.nix
		./packages.nix
		./file-system.nix
		./hardware-configuration.nix
	];

	networking.hostName = systemInfo.host;
	system.stateVersion = systemInfo.stateVersion;

	users = {
		users.${systemInfo.user} = {
			isNormalUser = true;
			shell = pkgs.zsh;
			extraGroups = [
				"networkmanager"
				"wheel"
			];
		};
		groups.${systemInfo.user} = {};
	};

	home-manager = {
		useGlobalPkgs = true;
		useUserPackages = true;
		extraSpecialArgs = { inherit inputs; };
		users.${systemInfo.user} = { ... }: {
			imports = [
				./../../home
			];
			home = {
				username = systemInfo.user;
				homeDirectory = "/home/${systemInfo.user}";
				stateVersion = systemInfo.stateVersion;
			};
		};
	};
}
