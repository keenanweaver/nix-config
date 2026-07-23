{
  flake.modules = {
    homeManager.zen-browser =
      {
        pkgs,
        inputs,
        ...
      }:
      {
        imports = [
          inputs.zen-browser.homeModules.beta
        ];
        home.sessionVariables = {
          MOZ_ENABLE_WAYLAND = 1;
        };
        programs.zen-browser = {
          enable = true;
          policies =
            let
              mkExtensionEntry =
                {
                  id,
                  pinned ? false,
                }:
                let
                  base = {
                    install_url = mkPluginUrl id;
                    installation_mode = "force_installed";
                  };
                in
                if pinned then base // { default_area = "navbar"; } else base;
              mkExtensionSettings = builtins.mapAttrs (
                _: entry: if builtins.isAttrs entry then entry else mkExtensionEntry { id = entry; }
              );
              mkPluginUrl = id: "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
            in
            {
              AutofillAddressEnabled = false;
              AutofillCreditCardEnabled = false;
              Cookies = {
                Allow = [
                  "https://claude.ai"
                  "https://codeberg.org"
                  "https://echosector.org"
                  "https://github.com"
                  "https://gog.com"
                  "https://kagi.com"
                  "https://proton.me"
                  "https://protonmail.com"
                  "https://qobuz.com"
                  "https://redlib.catsarch.com"
                  "https://steamcommunity.com"
                  "https://steampowered.com"
                  "https://store.epicgames.com"
                  "https://twitch.tv"
                  "https://zoom-platform.com"
                ];
                Behavior = "reject-tracker";
                BehaviorPrivateBrowsing = "reject-tracker";
                Locked = true;
              };
              DisableAppUpdate = true;
              DisableFeedbackCommands = true;
              DisableFirefoxStudies = true;
              DisableFormHistory = true;
              DisablePocket = true;
              DisableTelemetry = true;
              DontCheckDefaultBrowser = true;
              EnableTrackingProtection = {
                Cryptomining = true;
                Fingerprinting = true;
                Locked = true;
                Value = true;
              };
              ExtensionSettings = mkExtensionSettings {
                "7esoorv3@alefvanoon.anonaddy.me" = mkExtensionEntry {
                  id = "libredirect";
                  pinned = true;
                };
                "addon@darkreader.org" = mkExtensionEntry {
                  id = "darkreader";
                  pinned = true;
                };
                "admin@fastaddons.com_AutoHighlight" = "auto_highlight";
                "jid1-xUfzOsOFlzSOXg@jetpack" = "reddit-enhancement-suite";
                "plasma-browser-integration@kde.org" = "plasma-integration";
                "sponsorBlocker@ajay.app" = "sponsorblock";
                "uBlock0@raymondhill.net" = mkExtensionEntry {
                  id = "ublock-origin";
                  pinned = true;
                };
                "{00000f2a-7cde-4f20-83ed-434fcb420d71}" = "imagus";
                "{0c2c1d5d-7040-4499-9d29-bff606d963e6}" = "gog-2nd-class-helper";
                "{15bdb1ce-fa9d-4a00-b859-66c214263ac0}" = "get-rss-feed-url";
                "{1be309c5-3e4f-4b99-927d-bb500eb4fa88}" = "augmented-steam";
                "{446900e4-71c2-419f-a6a7-df9c091e268b}" = mkExtensionEntry {
                  id = "bitwarden-password-manager";
                  pinned = true;
                };
                "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" = mkExtensionEntry {
                  id = "styl-us";
                  pinned = true;
                };
                "{891ed2be-6ca9-47d1-9466-1595afa33b80}" = "bandcamp";
                "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" = "refined-github-";
                "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}" = "violentmonkey";
                "{b5501fd1-7084-45c5-9aa6-567c2fcf5dc6}" = "ruffle_rs";
              };
              FirefoxHome = {
                Locked = true;
                Search = false;
                SponsoredTopSites = false;
                TopSites = false;
              };
              GenerativeAI = {
                Enabled = false;
                Locked = true;
              };
              NoDefaultBookmarks = true;
              OfferToSaveLogins = false;
            };
          profiles.default =
            let
              pins = {
                "NixOS" = {
                  editedTitle = true;
                  folderIcon = "chrome://browser/skin/zen-icons/selectable/eye.svg";
                  id = "d85a9026-1458-4db6-b115-346746bcc692";
                  isFolderCollapsed = false;
                  isGroup = true;
                  position = 200;
                };
                "NixOS Manual" = {
                  folderParentId = pins."NixOS".id;
                  id = "c4804f6b-4523-4a33-99e4-c1f545390ad8";
                  position = 202;
                  url = "https://nixos.org/manual/nixos/unstable/";
                };
                "NixOS Status" = {
                  folderParentId = pins."NixOS".id;
                  id = "a018d0d9-4186-43bd-800e-821304da849e";
                  position = 201;
                  url = "https://status.nixos.org/";
                };
                "Nixpkgs Reference Manual" = {
                  folderParentId = pins."NixOS".id;
                  id = "8db8f1ff-f387-4eba-ab6b-2f03b1fe2291";
                  position = 203;
                  url = "https://nixos.org/manual/nixpkgs/unstable/";
                };
              };
            in
            {
              inherit pins;
              pinsForce = true;
              pinsForceAction = "demote";
              presets = {
                betterfox.enable = true;
                catppuccin = {
                  enable = true;
                  accent = "Lavender";
                  flavor = "Mocha";
                };
              };
              search = {
                default = "kagi";
                engines = {
                  "amazondotcom-us".metaData.hidden = true;
                  arch-wiki =
                    let
                      icon = pkgs.fetchurl {
                        hash = "sha256-ch3GhCHN435rHri15r8vdnva9AHkZSeaG5bgXCuXbVw=";
                        url = "https://upload.wikimedia.org/wikipedia/commons/thumb/1/13/Arch_Linux_%22Crystal%22_icon.svg/3840px-Arch_Linux_%22Crystal%22_icon.svg.png";
                      };
                    in
                    {
                      inherit icon;
                      definedAliases = [ "@aw" ];
                      name = "Arch Wiki";
                      urls = [ { template = "https://archwiki.org/wiki/Special:Search?search={searchTerms}&go=1"; } ];
                    };
                  "bing".metaData.hidden = true;
                  doom-wiki =
                    let
                      icon = pkgs.fetchurl {
                        hash = "sha256-5vlmRvQIBoPbWddOr1B2wE5h1nHze7D2ezNEPJm8Gm0=";
                        url = "https://cdn2.steamgriddb.com/icon/53b884037039b8150835431dd7ed95b0.png";
                      };
                    in
                    {
                      inherit icon;
                      definedAliases = [ "@dw" ];
                      name = "DoomWiki";
                      urls = [ { template = "https://doomwiki.org/wiki/Special:Search?search={searchTerms}&go=1"; } ];
                    };
                  "ebay".metaData.hidden = true;
                  github = {
                    definedAliases = [ "@gh" ];
                    name = "GitHub";
                    urls = [ { template = "https://github.com/search?q={searchTerms}"; } ];
                  };
                  gogdb =
                    let
                      icon = pkgs.fetchurl {
                        hash = "sha256-jyIXBJU1GxwCjTNwpXLAcj/NrdtuZAr0FmufQzCqt0s=";
                        url = "https://www.gogdb.org/static/img/gogdb_8f221704.svg";
                      };
                    in
                    {
                      inherit icon;
                      definedAliases = [ "@gogdb" ];
                      name = "GOGdb";
                      urls = [ { template = "https://www.gogdb.org/products?search={searchTerms}"; } ];
                    };
                  "google".metaData.hidden = true;
                  home-manager = {
                    definedAliases = [ "@hm" ];
                    name = "Home Manager Options";
                    urls = [ { template = "https://home-manager-options.extranix.com/?query={searchTerms}"; } ];
                  };
                  kagi =
                    let
                      icon = pkgs.fetchurl {
                        hash = "sha256-osunvYyex5xsHApv3Ui/EJHRuZ4E6aLsajKLb4o3n/k=";
                        url = "https://play-lh.googleusercontent.com/bvC_QEAI9VJxUZjYGdinGWsbRHQsOPQnwRs_mtirNt3QuIDMnD1CysHzpgGAZ94t_eJbOIXrgrP4PYmGJ-fyroI=w240-h480-rw";
                      };
                    in
                    {
                      inherit icon;
                      definedAliases = [ "@kg" ];
                      name = "Kagi";
                      urls = [ { template = "https://kagi.com/search?q={searchTerms}"; } ];
                    };
                  nixpkgs-options = {
                    definedAliases = [ "@nixo" ];
                    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                    name = "NixOS Options";
                    urls = [
                      {
                        template = "https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={searchTerms}";
                      }
                    ];
                  };
                  nixpkgs-packages = {
                    definedAliases = [ "@nixp" ];
                    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                    name = "NixOS Packages";
                    urls = [
                      {
                        template = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={searchTerms}";
                      }
                    ];
                  };
                  pcgw =
                    let
                      icon = pkgs.fetchurl {
                        hash = "sha256-35qnukMBMF1It5H6L/iD3S05iG6+prKkHNYHo/Rx0JA=";
                        url = "https://cdn-icons-png.flaticon.com/512/10069/10069193.png";
                      };
                    in
                    {
                      inherit icon;
                      definedAliases = [ "@pcgw" ];
                      name = "PCGamingWiki";
                      urls = [
                        {
                          template = "https://www.pcgamingwiki.com/w/index.php?search={searchTerms}&title=Special%3ASearch";
                        }
                      ];
                    };
                };
                force = true;
              };
              settings = {
                "browser.aboutConfig.showWarning" = false;
                "browser.compactmode.show" = true;
                "browser.download.deletePrivate" = true;
                "browser.eme.ui.enabled" = true;
                "browser.newtabpage.enabled" = false;
                "browser.sessionstore.max_tabs_undo" = 100;
                "browser.sessionstore.max_windows_undo" = 20;
                "browser.sessionstore.restore_on_demand" = false;
                "browser.sessionstore.resume_from_crash" = true;
                "browser.tabs.allow_transparent_browser" = true;
                "browser.toolbars.bookmarks.visibility" = "always";
                "general.autoScroll" = true;
                "general.smoothScroll" = true;
                "general.smoothScroll.mouseWheel.durationMinMS" = 80;
                "general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS" = 12;
                "general.smoothScroll.msdPhysics.enabled" = true;
                "general.smoothScroll.msdPhysics.motionBeginSpringConstant" = 600;
                "general.smoothScroll.msdPhysics.regularSpringConstant" = 650;
                "general.smoothScroll.msdPhysics.slowdownMinDeltaMS" = 25;
                "general.smoothScroll.msdPhysics.slowdownSpringConstant" = 250;
                "general.smoothScroll.stopDecelerationWeighting" = 0.6;
                "gfx.font_rendering.cleartype_params.rendering_mode" = 5;
                "gfx.wayland.hdr" = true;
                "gfx.webrender.all" = true;
                "media.autoplay.default" = 5;
                "media.eme.enabled" = true;
                "media.ffmpeg.vaapi.enable" = true;
                "middlemouse.paste" = false;
                "mousewheel.min_line_scroll_amount" = 10;
                "services.sync.engine.workspaces" = true;
                "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
                "widget.use-xdg-desktop-portal.file-picker" = true;
                "widget.use-xdg-desktop-portal.mime-handler" = true;
                "zen.tabs.show-newtab-vertical" = true;
                "zen.tabs.vertical" = true;
                "zen.theme.gradient.show-custom-colors" = true;
                "zen.ui.migration.compact-mode-button-added" = true;
                "zen.view.compact.enable-at-startup" = true;
                "zen.view.compact.hide-tabbar" = true;
                "zen.view.compact.hide-toolbar" = true;
                "zen.view.compact.show-sidebar-and-toolbar-on-hover" = true;
                "zen.view.use-single-toolbar" = false;
                "zen.welcome-screen.seen" = true;
                "zen.window-sync.enabled" = false;
                "zen.window-sync.sync-only-pinned-tabs" = true;
                "zen.workspaces.continue-where-left-off" = false;
                "zen.workspaces.enabled" = true;
                "zen.workspaces.show-workspace-indicator" = true;
              };
            };
          setAsDefaultBrowser = true;
        };
      };
  };
  flake-file.inputs = {
    zen-browser = {
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:0xc000022070/zen-browser-flake";
    };
  };
}
