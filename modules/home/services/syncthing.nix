{ pkgs, ... }:
{
	services.syncthing = {
		enable = true;
		package = pkgs.syncthing;
		guiAddress = "127.0.0.1:8384";
		settings = {
			options = {
				localAnnounceEnabled = true;
			};
		};
		tray = {
			enable = true;
			package = pkgs.syncthingtray-minimal;
			command = "syncthingtray --wait";
		};
	};
}
