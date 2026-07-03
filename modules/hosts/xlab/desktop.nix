{ lib, config, systemInfo, ... }:
{
	security.polkit.enable = true;
	security.pam.services.swaylock = lib.mkIf config.home-manager.users.${systemInfo.user}.programs.swaylock.enable {};
	services.gnome.gnome-keyring.enable = true;

	services.displayManager.ly = {
		enable = true;
		x11Support = false;
	};
	programs.mango = {
		enable = true;
		addLoginEntry = true;
	};
}
