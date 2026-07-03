{ ... }:
{
	environment.etc."libinput/local-overrides.conf".text = ''
		[Serial Keyboards]
		MatchUdevType=keyboard
		MatchName=keyd virtual keyboard
		AttrKeyboardIntegration=internal
	'';
	services.keyd = {
		enable = true;
		keyboards = {
			default = {
				ids = [ "*" ];
				settings = {
					main = {
						capslock = "overload(control, esc)";
					};
				};
			};
		};
	};
}
