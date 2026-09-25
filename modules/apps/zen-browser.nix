{
  flake.modules.homeManager.zen-browser =
    {
      inputs,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.zen-browser.homeModules.beta
      ];
      home.sessionVariables.MOZ_ENABLE_WAYLAND = 1;
      programs.zen-browser = {
        enable = true;
        nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ];
        policies =
          let
            mkExtensionSettings = builtins.mapAttrs (
              _: pluginId: {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
                installation_mode = "force_installed";
              }
            );
          in
          {
            AutofillAddressEnabled = false;
            AutofillCreditCardEnabled = false;
            Cookies = {
              Allow = [
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
                "https://tangled.org"
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
              EmailTracking = true;
              Fingerprinting = true;
              Locked = true;
              SuspectedFingerprinting = true;
              Value = true;
            };
            ExtensionSettings =
              mkExtensionSettings {
                "7esoorv3@alefvanoon.anonaddy.me" = "libredirect";
                "addon@darkreader.org" = "darkreader";
                "admin@fastaddons.com_AutoHighlight" = "auto_highlight";
                "jid1-xUfzOsOFlzSOXg@jetpack" = "reddit-enhancement-suite";
                "plasma-browser-integration@kde.org" = "plasma-integration";
                "sponsorBlocker@ajay.app" = "sponsorblock";
                "uBlock0@raymondhill.net" = "ublock-origin";
                "{00000f2a-7cde-4f20-83ed-434fcb420d71}" = "imagus";
                "{0c2c1d5d-7040-4499-9d29-bff606d963e6}" = "gog-2nd-class-helper";
                "{15bdb1ce-fa9d-4a00-b859-66c214263ac0}" = "get-rss-feed-url";
                "{1be309c5-3e4f-4b99-927d-bb500eb4fa88}" = "augmented-steam";
                "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
                "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" = "styl-us";
                "{891ed2be-6ca9-47d1-9466-1595afa33b80}" = "bandcamp";
                "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" = "refined-github-";
                "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}" = "violentmonkey";
                "{b5501fd1-7084-45c5-9aa6-567c2fcf5dc6}" = "ruffle_rs";
              }
              // {
                "*".installation_mode = "blocked";
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
            HttpsOnlyMode = "force_enabled";
            NoDefaultBookmarks = true;
            OfferToSaveLogins = false;
            SSLVersionMin = "tls1.2";
            SanitizeOnShutdown = {
              Cache = true;
              Cookies = true;
              Downloads = true;
              FormData = true;
              History = true;
              Locked = true;
              OfflineApps = true;
              Sessions = true;
              SiteSettings = true;
            };
          };
        profiles.default =
          let
            defaultSpace = "5a9a807c-9689-4e11-8cf6-162a22118ab7";
            nixSnowflake = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          in
          {
            containersForce = true;
            extensionButtons = {
              nav-bar = [
                "uBlock0@raymondhill.net"
                "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" # styl-us
                "{446900e4-71c2-419f-a6a7-df9c091e268b}" # bitwarden-password-manager
                "7esoorv3@alefvanoon.anonaddy.me" # libredirect
              ];
              unified-extensions-area = [
                "admin@fastaddons.com_AutoHighlight"
                "sponsorBlocker@ajay.app"
                "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" # refined-github-
                "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}" # violentmonkey
                "{b5501fd1-7084-45c5-9aa6-567c2fcf5dc6}" # ruffle_rs
                "{891ed2be-6ca9-47d1-9466-1595afa33b80}" # bandcamp
                "plasma-browser-integration@kde.org"
                "{15bdb1ce-fa9d-4a00-b859-66c214263ac0}" # get-rss-feed-url
                "addon@darkreader.org"
              ];
            };
            mods = [
              "e122b5d9-d385-4bf8-9971-e137809097d0" # No Top Sites
              "253a3a74-0cc4-47b7-8b82-996a64f030d5" # Floating History
              "4ab93b88-151c-451b-a1b7-a1e0e28fa7f8" # No Sidebar Scrollbar
              "7190e4e9-bead-4b40-8f57-95d852ddc941" # Tab title fixes
              "803c7895-b39b-458e-84f8-a521f4d7a064" # Hide Inactive Workspaces
              "906c6915-5677-48ff-9bfc-096a02a72379" # Floating Status Bar
              "a6335949-4465-4b71-926c-4a52d34bc9c0" # Better Find Bar
              "5c4d7772-d963-4672-ab03-e9d541438881" # Bigger Mute Button
              "bc25808c-a012-4c0d-ad9a-aa86be616019" # sleek border
            ];
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
                "Home Manager Options" = {
                  definedAliases = [ "@hm" ];
                  urls = [
                    {
                      params = [
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                        {
                          name = "release";
                          value = "master";
                        }
                      ];
                      template = "https://home-manager-options.extranix.com/";
                    }
                  ];
                };
                "Nix Options" = {
                  definedAliases = [ "@nixo" ];
                  icon = nixSnowflake;
                  urls = [
                    {
                      params = [
                        {
                          name = "channel";
                          value = "unstable";
                        }
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                      ];
                      template = "https://search.nixos.org/options";
                    }
                  ];
                };
                "Nix Packages" = {
                  definedAliases = [ "@nixp" ];
                  icon = nixSnowflake;
                  urls = [
                    {
                      params = [
                        {
                          name = "type";
                          value = "packages";
                        }
                        {
                          name = "channel";
                          value = "unstable";
                        }
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                      ];
                      template = "https://search.nixos.org/packages";
                    }
                  ];
                };
                "NixOS Wiki" = {
                  definedAliases = [ "@nixw" ];
                  icon = nixSnowflake;
                  urls = [
                    {
                      params = [
                        {
                          name = "search";
                          value = "{searchTerms}";
                        }
                      ];
                      template = "https://wiki.nixos.org/w/index.php";
                    }
                  ];
                };
                amazondotcom-us.metaData.hidden = true;
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
                bing.metaData.hidden = true;
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
                ebay.metaData.hidden = true;
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
                google.metaData.hidden = true;
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
                mynixos = {
                  definedAliases = [ "@mn" ];
                  icon = nixSnowflake;
                  name = "MyNixOS";
                  urls = [ { template = "https://mynixos.com/search?q={searchTerms}"; } ];
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
              "mod.ivaon.urlbar.hide_results" = 0; # No Top Sites
              "mousewheel.min_line_scroll_amount" = 10;
              "psu.tab_title_fixes.font_size" = "13px"; # Tab title fixes
              "psu.tab_title_fixes.pending_opacity" = "0.55";
              "services.sync.engine.workspaces" = true;
              "signon.rememberSignons" = false;
              theme-better_find_bar-enable_custom_background = false; # Better Find Bar
              "theme.better_find_bar.hide_find_status" = false;
              "theme.better_find_bar.hide_found_matches" = false;
              "theme.better_find_bar.hide_highlight" = "not_hide";
              "theme.better_find_bar.hide_match_case" = "not_hide";
              "theme.better_find_bar.hide_match_diacritics" = "hide_immediately";
              "theme.better_find_bar.hide_whole_words" = "not_hide";
              "theme.better_find_bar.horizontal_position" = "default";
              "theme.better_find_bar.instant_animations" = true;
              "theme.better_find_bar.textbox_width" = "800";
              "theme.better_find_bar.transparent_background" = true;
              "theme.better_find_bar.vertical_position" = "default";
              "theme.floating_history.position" = "right"; # Floating History
              "theme.nosidebarscrollbar.before125b" = false; # No Sidebar Scrollbar
              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
              "widget.use-xdg-desktop-portal.file-picker" = true;
              "widget.use-xdg-desktop-portal.mime-handler" = true;
              "zen.tabs.show-newtab-vertical" = true;
              "zen.tabs.vertical" = true;
              "zen.theme.gradient.show-custom-colors" = true;
              "zen.theme.hide-unified-extensions-button" = false;
              "zen.ui.migration.compact-mode-button-added" = true;
              "zen.urlbar.behavior" = "float";
              "zen.view.compact.animate-sidebar" = true;
              "zen.view.compact.enable-at-startup" = true;
              "zen.view.compact.hide-tabbar" = true;
              "zen.view.compact.hide-toolbar" = true;
              "zen.view.compact.show-sidebar-and-toolbar-on-hover" = true;
              "zen.view.use-single-toolbar" = false;
              "zen.welcome-screen.seen" = true;
              "zen.window-sync.enabled" = true;
              "zen.window-sync.sync-only-pinned-tabs" = true;
              "zen.workspaces.continue-where-left-off" = false;
              "zen.workspaces.enabled" = true;
              "zen.workspaces.natural-scroll" = true;
              "zen.workspaces.show-workspace-indicator" = true;
            };
            spaceRouting = {
              defaultExternalRoute = defaultSpace;
              force = true;
            };
            spaces.Space = {
              id = defaultSpace;
              liveFolders = {
                "My issues" = {
                  github.authorMe = true;
                  id = "069ddf06-972e-43b2-8683-1ee2505b07a3";
                  kind = "github:issues";
                  position = 301;
                };
                "Pull requests" = {
                  github = {
                    assignedMe = true;
                    authorMe = true;
                    reviewRequested = true;
                  };
                  id = "c66b4bfa-5f69-49e6-857e-b76ac5eb179b";
                  kind = "github:pull-requests";
                  position = 300;
                };
              };
              pins.NixOS = {
                editedTitle = true;
                folderIcon = "file://${nixSnowflake}";
                id = "d85a9026-1458-4db6-b115-346746bcc692";
                isFolderCollapsed = false;
                pins = {
                  MyNixOS = {
                    id = "b22bef9f-4359-4025-aa40-77cea0d2f3a8";
                    position = 204;
                    url = "https://mynixos.com/";
                  };
                  "NixOS Manual" = {
                    id = "c4804f6b-4523-4a33-99e4-c1f545390ad8";
                    position = 202;
                    url = "https://nixos.org/manual/nixos/unstable/";
                  };
                  "NixOS Status" = {
                    id = "a018d0d9-4186-43bd-800e-821304da849e";
                    position = 201;
                    url = "https://status.nixos.org/";
                  };
                  "Nixpkgs Reference Manual" = {
                    id = "8db8f1ff-f387-4eba-ab6b-2f03b1fe2291";
                    position = 203;
                    url = "https://nixos.org/manual/nixpkgs/unstable/";
                  };
                };
                position = 200;
              };
              position = 1000;
            };
            spacesForce = true;
            userChrome = ''
              @import "catppuccin/userChrome.css";

              :root {
                --panel-background-color: #1e1e2e !important;
              }

              #zen-browser-background {
                --zen-main-browser-background: #181825 !important;
              }
            '';
          };
        setAsDefaultBrowser = true;
      };
    };
  flake-file.inputs.zen-browser = {
    inputs = {
      home-manager.follows = "home-manager";
      nixpkgs.follows = "nixpkgs";
    };
    url = "github:0xc000022070/zen-browser-flake";
  };
}
