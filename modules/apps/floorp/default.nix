{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.floorp;
in
{
  options = {
    floorp = {
      enable = lib.mkEnableOption "Enable floorp in home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      # Depends on https://github.com/nix-community/home-manager/pull/5128
      programs.firefox = {
        enable = true;
        package = pkgs.floorp;
        policies = {
          AllowFileSelectionDialogs = true;
          AppAutoUpdate = false;
          AutofillAddressEnabled = false;
          AutofillCreditCardEnabled = false;
          #AutoLaunchProtocolsFromOrigins = { };
          BackgroundAppUpdate = false;
          BlockAboutAddons = false;
          BlockAboutConfig = false;
          BlockAboutProfiles = false;
          BlockAboutSupport = false;
          #Containers = { };
          DisableAppUpdate = true;
          DisableFirefoxAccounts = false;
          DisableFirefoxScreenshots = true;
          DisableFirefoxStudies = true;
          DisableFormHistory = true;
          DisableMasterPasswordCreation = true;
          DisablePocket = false;
          DisablePrivateBrowsing = false;
          DisableProfileImport = false;
          DisableProfileRefresh = false;
          DisableSafeMode = false;
          DisableTelemetry = true;
          DNSOverHTTPS = {
            Enabled = false;
          };
          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
          EncryptedMediaExtensions = {
            Enabled = true;
          };
          ExtensionSettings = {
            "*" = {
              blocked_install_message = "Addon is not added in the nix config";
              installation_mode = "blocked";
            };
            "{00000f2a-7cde-4f20-83ed-434fcb420d71}" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/imagus/latest.xpi";
            };
            "{1be309c5-3e4f-4b99-927d-bb500eb4fa88}" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/augmented-steam/latest.xpi";
            };
            "{15bdb1ce-fa9d-4a00-b859-66c214263ac0}" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/get-rss-feed-url/latest.xpi";
            };
            "{252ee273-8c8d-4609-b54d-62ae345be0a1}" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/indicatetls/latest.xpi";
            };
            "{3c6bf0cc-3ae2-42fb-9993-0d33104fdcaf}" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/youtube-addon/latest.xpi";
            };
            "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
              installation_mode = "force_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
            };
            "{569456be-2850-4f7e-b669-71e55140ee0a}" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/amp2html/latest.xpi";
            };
            "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/styl-us/latest.xpi";
            };
            "{76ef94a4-e3d0-4c6f-961a-d38a429a332b}" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/ttv-lol-pro/latest.xpi";
            };
            "{891ed2be-6ca9-47d1-9466-1595afa33b80}" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/bandcamp/latest.xpi";
            };
            "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/refined-github-/latest.xpi";
            };
            "{b5501fd1-7084-45c5-9aa6-567c2fcf5dc6}" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/ruffle_rs/latest.xpi";
            };
            "{f209234a-76f0-4735-9920-eb62507a54cd}" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/unpaywall/latest.xpi";
            };
            "7esoorv3@alefvanoon.anonaddy.me" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/libredirect/latest.xpi";
            };
            "admin@fastaddons.com_AutoHighlight" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/auto_highlight/latest.xpi";
            };
            "DontFuckWithPaste@raim.ist" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/don-t-fuck-with-paste/latest.xpi";
            };
            "FirefoxColor@mozilla.com" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/firefox-color/latest.xpi";
            };
            "firemonkey@eros.man" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/firemonkey/latest.xpi";
            };
            "frankerfacez@frankerfacez.com" = {
              installation_mode = "normal_installed";
              install_url = "https://cdn.frankerfacez.com/script/frankerfacez-4.0-an+fx.xpi";
            };
            "freshrss-checker@addons.mozilla.org" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/freshrss-checker/latest.xpi";
            };
            "jid1-QoFqdK4qzUfGWQ@jetpack" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/dark-background-light-text/latest.xpi";
            };
            "jid1-xUfzOsOFlzSOXg@jetpack" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/reddit-enhancement-suite/latest.xpi";
            };
            "magnolia@12.34" = {
              installation_mode = "normal_installed";
              install_url = "https://github.com/bpc-clone/bpc_updates/releases/download/latest/bypass_paywalls_clean-3.7.1.0.xpi";
            };
            "plasma-browser-integration@kde.org" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/plasma-integration/latest.xpi";
            };
            "private-relay@firefox.com" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/private-relay/latest.xpi";
            };
            "sponsorBlocker@ajay.app" = {
              installation_mode = "normal_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
            };
            "uBlock0@raymondhill.net" = {
              installation_mode = "force_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            };
          };
          ExtensionUpdate = true;
          FirefoxHome = {
            Search = false;
            TopSites = false;
            SponsoredTopSites = false;
            Highlights = false;
            Pocket = true;
            SponsoredPocket = false;
            Snippets = false;
            Locked = false;
          };
          HardwareAcceleration = true;
          ManualAppUpdateOnly = true;
          NoDefaultBookmarks = true;
          OfferToSaveLogins = false;
          PasswordManagerEnabled = false;
          PictureInPicture = {
            Enabled = true;
          };
          PopupBlocking = {
            Allow = [ ];
            Default = false;
          };
          Preferences = {
            "browser.tabs.warnOnClose" = {
              Value = false;
            };
          };
          PromptForDownloadLocation = true;
          UserMessaging = {
            ExtensionRecommendations = false;
            SkipOnboarding = true;
          };
        };
        profiles = {
          "${username}" = {
            settings = {
              # Disable auto-update
              "app.update.channel" = "default";
              "app.update.service.enabled" = false;
              "app.update.download.promptMaxAttempts" = 0;
              "app.update.elevation.promptMaxAttempts" = 0;
              "browser.shell.checkDefaultBrowser" = false;
              "extensions.autoDisableScopes" = 0;
              # Extension settings
              "extensions.screenshots.disabled" = true;
              # Download settings
              "browser.download.useDownloadDir" = false;
              # Mouse settings
              "general.autoScroll" = true;
              "general.smoothScroll" = true;
              "mousewheel.min_line_scroll_amount" = 60;
              # Disable autofill & passwords
              "browser.formfill.enable" = false;
              "extensions.formautofill.addresses.enabled" = false;
              "extensions.formautofill.creditCards.enabled" = false;
              "signon.management.page.breach-alerts.enabled" = false;
              "signon.rememberSignons" = false;
              "signon.autofillForms" = false;
              # Disable autoplay with sound
              "media.autoplay.default" = 1;
              # DRM content
              "browser.eme.ui.enabled" = true;
              "media.eme.enabled" = true;
              # Bookmarks
              "browser.bookmarks.showMobileBookmarks" = false;
              # Hardware acceleration
              "gfx.webrender.all" = true;
              "media.ffmpeg.vaapi.enabled" = true;
              # KDE integration
              "widget.use-xdg-desktop-portal.file-picker" = 1;
              "widget.use-xdg-desktop-portal.mime-handler" = 1;
              # Theming options
              "font.name.monospace.x-western" = "JetBrainsMono Nerd Font";
              "font.name.sans-serif.x-western" = "IBM Plex Sans";
              "font.name.serif.x-western" = "IBM Plex Serif";
              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
              # Privacy options
              "browser.contentblocking.category" = "strict";
              "privacy.clearOnShutdown.history" = false;
              "privacy.clearOnShutdown.offlineApps" = true;
              # Search options
              "browser.search.region" = "US";
              "browser.search.separatePrivateDefault" = false;
              "browser.urlbar.showSearchSuggestionsFirst" = false;
              "browser.urlbar.suggest.searches" = false;
              # Floorp specific
              "browser.newtabpage.activity-stream.feeds.topsites" = false;
              "browser.newtabpage.activity-stream.floorp.background.type" = 0;
              "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
              "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
              "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
              "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
              "browser.newtabpage.activity-stream.showSponsored" = false;
              "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
              "browser.newtabpage.activity-stream.topSitesRows" = 2;
              "browser.proton.toolbar.version" = 3;
              "browser.tabs.inTitlebar" = 1;
              "browser.tabs.warnOnClose" = false;
              "floorp.browser.sidebar.enable" = false;
              "floorp.browser.sidebar.is.displayed" = false;
              "floorp.browser.sidebar.right" = false;
              "floorp.browser.tabs.verticaltab.width" = 208;
              "floorp.browser.user.interface" = 1;
              "floorp.chrome.theme.mode" = 1;
              "floorp.download.notification" = 2;
              "floorp.downloading.red.color" = false;
              "floorp.extensions.allowPrivateBrowsingByDefault.is.enabled" = true;
              "floorp.hide.unifiedExtensionsButtton" = false;
              "floorp.legacy.dlui.enable" = true;
              "floorp.lepton.interface" = 3;
              "floorp.tabsleep.enabled" = true;
              "floorp.verticaltab.hover.enabled" = true;
              "floorp.verticaltab.show.newtab.button" = true;
              "floorp.Tree-type.verticaltab.optimization" = false;
            };
          };
        };
      };
    };
  };
}
