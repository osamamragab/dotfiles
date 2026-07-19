{
    inputs,
    pkgs,
    lib,
    config,
    ...
}:
let
    firefox-addons = pkgs.nur.repos.rycee.firefox-addons;
    addonPackages = with firefox-addons; [
        multi-account-containers
        ublock-origin
        sponsorblock
        dearrow
        chrome-mask
        clearurls
        decentraleyes
        istilldontcareaboutcookies
        darkreader
        vimium-c
        wayback-machine
        search-by-image
        youtube-nonstop
        cookie-editor
        header-editor
        visbug
        theme-nord-polar-night
    ];
    mkAddonSettings = addon: extraSettings: {
        ${addon.addonId}.settings = {
            default_area = "menupanel";
            private_browsing = true;
        }
        // extraSettings;
    };
in
{
    imports = [
        inputs.arkenfox.hmModules.arkenfox
    ];

    programs.firefox = {
        enable = true;
        package = pkgs.firefox;
        enableGnomeExtensions = false;
        arkenfox.enable = true;
        profiles.default = {
            id = 0;
            name = "default";
            isDefault = true;
            search = {
                force = true;
                default = "ddg";
                privateDefault = "ddg";
                order = [
                    "ddg"
                    "google"
                    "wikipedia"
                    "youtube"
                ];
                engines = {
                    bing.metaData.hidden = true;
                    google.metaData.alias = "@g";
                    youtube = {
                        name = "YouTube";
                        urls = [
                            {
                                template = "https://www.youtube.com/results";
                                params = [
                                    {
                                        name = "search_query";
                                        value = "{searchTerms}";
                                    }
                                ];
                            }
                        ];
                        icon = "https://youtube.com/favicon.ico";
                        definedAliases = [ "@yt" ];
                    };
                };
            };
            extensions = {
                force = true;
                packages = addonPackages;
                settings = builtins.foldl' (
                    acc: addon: acc // mkAddonSettings addon { }
                ) { } addonPackages;
            };
            arkenfox = {
                enable = true;
                enableAllSections = true;
                "0100"."0102"."browser.startup.page".value = 3;
                "1000"."1001"."browser.cache.disk.enable".value = true;
                "2800"."2810"."privacy.sanitize.sanitizeOnShutdown".value = false;
                "0800"."0803" = {
                    "browser.search.suggest.enabled".value = true;
                    "browser.urlbar.suggest.searches".value = true;
                };
                "5000"."5002" = {
                    "browser.cache.memory.enable".value = true;
                    "browser.cache.memory.capacity".value = 512000;
                };
                "1200" = {
                    "1201"."security.ssl.require_safe_negotiation".value = false;
                    "1244"."dom.security.https_only_mode".value = false;
                };
            };
            settings = {
                "accessibility.force_disabled" = 1;
                "accessibility.typeaheadfind.enablesound" = false;
                "browser.uidensity" = 1;
                "browser.theme.content-theme" = 2;
                "browser.startup.couldRestoreSession.count" = 3;
                "browser.sessionhistory.max_total_viewers" = 0;
                "browser.sessionstore.interval" = 30000;
                "browser.sessionstore.interval.idle" = 3600000;
                "browser.sessionhistory.max_entries" = 50;
                "browser.sessionstore.max_serialize_back" = 10;
                "browser.sessionstore.max_serialize_forward" = -1;
                "browser.tabs.min_inactive_duration_before_unload" = 600000;
                "browser.tabs.drawInTitlebar" = true;
                "browser.tabs.groups.smart.enabled" = false;
                "browser.tabs.hoverPreview.enabled" = false;
                "browser.tabs.hoverPreview.showThumbnails" = false;
                "browser.tabs.groups.hoverPreview.enabled" = false;
                "browser.tabs.groups.smart.userEnabled" = false;
                "browser.ml.enable" = false;
                "browser.ml.linkPreview.enabled" = false;
                "browser.ml.chat.enabled" = false;
                "browser.ml.chat.menu" = false;
                "browser.ml.chat.page" = false;
                "browser.ml.chat.page.footerBadge" = false;
                "browser.ml.chat.page.menuBadge" = false;
                "network.prefetch-next" = false;
                "network.http.referer.XOriginPolicy" = 0;
                "privacy.resistFingerprinting" = false;
                "privacy.resistFingerprinting.letterboxing" = false;
                "identity.fxaccounts.enabled" = true;
                "extensions.autoDisableScopes" = 0;
                "extensions.pocket.enabled" = false;
                "extensions.ml.enabled" = false;
                "layout.css.prefers-color-scheme.content-override" = 0;
                "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
                "gfx.font_rendering.opentype_svg.enabled" = true;
                "gfx.font_rendering.fontconfig.max_generic_substitutions" = 127;
                "gfx.webrender.all" = true;
                "media.eme.enabled" = true;
                "media.ffmpeg.vaapi.enabled" = true;
                "webgl.disabled" = false;
                "general.smoothScroll" = true;
                "sidebar.revamp" = true;
                "sidebar.revamp.round-content-area" = true;
                "sidebar.verticalTabs" = true;
                "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;
                "sidebar.visibility" = "always-show";
                "sidebar.notification.badge.aichat" = false;
                "font.name-list.emoji" = "emoji, Twemoji Mozilla";
            };
        };
    };

    home.sessionVariables = lib.optionalAttrs config.programs.firefox.enable {
        BROWSER = "firefox";
    };

    home.file."${config.xdg.binHome}/fftabs" =
        let
            dir =
                if config.xdg.enable then
                    "${config.xdg.configHome}/mozilla/firefox"
                else
                    "${config.home.homeDirectory}/.mozilla/firefox";
        in
        lib.mkIf config.programs.firefox.enable {
            source = pkgs.writeShellScript "fftabs" ''
                set -eu
                sed -n "s/Path=\(.*\)/\1/p" "${dir}/profiles.ini" | while IFS= read -r p; do
                    ${pkgs.dejsonlz4}/bin/dejsonlz4 "${dir}/$p/sessionstore-backups/recovery.jsonlz4" |
                        ${pkgs.jq}/bin/jq -r '.windows[].tabs[] | .entries[.index-1] | "\(.title) (\(.url))"'
                done
            '';
        };
}
