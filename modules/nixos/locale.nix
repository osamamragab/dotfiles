{ ... }:
{
    time.timeZone = "Africa/Cairo";
    i18n = {
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings = {
            LANGUAGE = "en_US:en_GB:en";
            LC_TIME = "C.UTF-8";
            LC_COLLATE = "C.UTF-8";
            LC_MEASUREMENT = "C.UTF-8";
        };
    };
}
