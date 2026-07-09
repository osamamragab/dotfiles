{ inputs, pkgs, lib, config, ... }:
{
    imports = [ inputs.arkenfox.hmModules.arkenfox ];
    programs.firefox = {
        enable = true;
        package = pkgs.firefox;
        enableGnomeExtensions = false;
        arkenfox.enable = true;
        profiles.default = {
            id = 0;
            name = "default";
            isDefault = true;
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

    home.sessionVariables.BROWSER = lib.mkIf config.programs.firefox.enable "firefox";
}
