{
    flake.aspects.base = {
        nixos = { lib, ... }: {
            time.timeZone = lib.mkDefault "Africa/Cairo";
            i18n = {
                defaultLocale = lib.mkDefault "en_US.UTF-8";
                extraLocaleSettings = {
                    LANGUAGE = lib.mkDefault "en_US:en_GB:en";
                    LC_TIME = lib.mkDefault "C.UTF-8";
                    LC_COLLATE = lib.mkDefault "C.UTF-8";
                    LC_MEASUREMENT = lib.mkDefault "C.UTF-8";
                };
            };
        };
    };
}
