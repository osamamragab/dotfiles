{ disko, inputs, ... }:
{
	disko.devices.disk.nvme0n1 = {
		type = "disk";
		device = "/dev/nvme0n1";
		content = {
			type = "gpt";
			partitions = {
				ESP = {
					label = "boot";
					name = "ESP";
					size = "1G";
					type = "EF00";
					content = {
						type = "filesystem";
						format = "vfat";
						mountpoint = "/boot";
						mountOptions = [
							"defaults"
								"umask=0077"
						];
					};
				};
				luks = {
					size = "100%";
					label = "luks";
					content = {
						type = "luks";
						name = "cryptroot";
						settings = {
							allowDiscards = true;
							#keyFile = "/tmp/secret.key";
						};
						content = {
							type = "btrfs";
							extraArgs = ["-L" "data" "-f"];
							subvolumes = {
								"/root" = {
									mountpoint = "/";
									mountOptions = ["subvol=root" "compress=zstd" "noatime"];
								};
								"/home" = {
									mountpoint = "/home";
									mountOptions = ["subvol=home" "compress=zstd" "noatime"];
								};
								"/nix" = {
									mountpoint = "/nix";
									mountOptions = ["subvol=nix" "compress=zstd" "noatime"];
								};
								"/log" = {
									mountpoint = "/var/log";
									mountOptions = ["subvol=log" "compress=zstd" "noatime"];
								};
								"/lib" = {
									mountpoint = "/var/lib";
									mountOptions = ["subvol=lib" "compress=zstd" "noatime"];
								};
								"/swap" = {
									mountpoint = "/var/swap";
									mountOptions = ["subvol=swap" "noatime" "nodatacow" "compress=no"];
									swap.swapfile.size = "18G";
								};
							};
						};
					};
				};
			};
		};
	};

	fileSystems = {
		"/var/log".neededForBoot = true;
		"/var/lib".neededForBoot = true;
		"/var/swap".neededForBoot = true;
	};

	services.btrfs.autoScrub = {
		enable = true;
		interval = "weekly";
		fileSystems = ["/"];
	};

	boot.initrd.luks.devices.cryptroot = {
		device = "/dev/disk/by-partlabel/luks";
		allowDiscards = true;
		preLVM = true;
	};

	zramSwap = {
		enable = true;
		algorithm = "zstd";
		priority = 5;
		memoryPercent = 50;
	};
}
