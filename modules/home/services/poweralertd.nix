{ pkgs, ... }:
{
	services.poweralertd = {
		enable = true;
		package = pkgs.poweralertd;
		extraArgs = [ "-s" ];
	};
}
