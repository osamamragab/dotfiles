{ pkgs, ... }:
{
    boot = {
        kernelPackages = pkgs.linuxPackages_zen;
        kernelParams = [
            "plymouth.use-simpledrm"
        ];
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
        plymouth = {
            enable = true;
            theme = "rings";
            themePackages = with pkgs; [
                (adi1090x-plymouth-themes.override {
                    selected_themes = ["rings"];
                })
            ];
        };
    };
}
