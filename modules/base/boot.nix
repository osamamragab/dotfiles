{
    flake.aspects.base = {
        nixos =
            {
                pkgs,
                lib,
                config,
                ...
            }:
            {
                boot = {
                    consoleLogLevel = 3;
                    tmp = {
                        useTmpfs = true;
                        tmpfsSize = "50%";
                        cleanOnBoot = true;
                    };
                    kernelParams = [
                        "quiet"
                        "systemd.show_status=auto"
                        "rd.udev.log_level=3"
                    ]
                    ++ lib.optional config.boot.plymouth.enable "plymouth.use-simpledrm";
                    kernel.sysctl = {
                        "vm.max_map_count" = 2 * 1024 * 1024 * 1024 - 1;
                        "vm.dirty_background_bytes" = 32 * 1024 * 1024;
                        "vm.dirty_bytes" = 128 * 1024 * 1024;
                        "net.ipv4.tcp_mtu_probing" = 2;
                    };
                    extraModprobeConfig = ''
                        # disable usb autosuspend
                        options usbcore autosuspend=-1

                        # disable wifi powersave
                        options iwlwifi power_save=0
                        options iwlmvm  power_scheme=1

                        # disable audio powersave
                        options snd_hda_intel power_save=0
                    '';
                    blacklistedKernelModules = [
                        "pcspkr"
                        "snd_pcsp"
                    ];
                    initrd = {
                        compressor = "zstd";
                        systemd.enable = true;
                    };
                    loader = {
                        efi.canTouchEfiVariables = true;
                        systemd-boot = {
                            enable = true;
                            configurationLimit = lib.mkDefault 10;
                            consoleMode = lib.mkDefault "max";
                        };
                    };
                    plymouth = {
                        enable = lib.mkDefault false;
                        theme = "hud_3";
                        themePackages = [
                            (pkgs.adi1090x-plymouth-themes.override {
                                selected_themes = [ config.boot.plymouth.theme ];
                            })
                        ];
                    };
                };
            };
    };
}
