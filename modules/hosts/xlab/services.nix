{ ... }:
{
	hardware.bluetooth.enable = true;

	services.printing.enable = true;

	services.keyd.keyboards = {
		redragon-k613 = {
			ids = [ "258a:002a" ];
			settings = {
				main = {
					capslock = "overload(control, esc)";
					esc = "`";
				};
			};
		};
	};
}
