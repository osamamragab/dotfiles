{ lib, ... }:
{
	boot = {
		consoleLogLevel = 3;
		tmp = {
			useTmpfs = true;
			tmpfsSize = "50%";
			cleanOnBoot = true;
		};
		extraModprobeConfig = ''
			# disable wifi powersave
			options iwlmvm  power_scheme=1
			options iwlwifi power_save=0
		'';
		kernelParams = [
			"quiet"
			"systemd.show_status=auto"
			"rd.udev.log_level=3"
			"plymouth.use-simpledrm"
		];
		kernel.sysctl = {
			"vm.max_map_count" = 2147483642;
			"vm.dirty_background_bytes"= 33554432;
			"vm.dirty_bytes"= 134217728;
			"net.ipv4.tcp_mtu_probing" = 2;
		};
		initrd.systemd.enable = true;
		loader = {
			efi.canTouchEfiVariables = true;
			systemd-boot = {
				enable = true;
				configurationLimit = 20;
				consoleMode = lib.mkDefault "max";
			};
		};
	};
}
