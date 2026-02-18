{
  inputs,
  lib,
  config,
  pkgs,
  username,
  vars,
  ...
}:
let
  cfg = config.kde;
in
{

  options = {
    kde = {
      enable = lib.mkEnableOption "Enable kde in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    environment = {
      plasma6.excludePackages = with pkgs.kdePackages; [ elisa ];
      sessionVariables = {
        GDK_DEBUG = "portals"; # KDE filepicker
        KWIN_DISABLE_TONEMAPPING = "1";
        QT_QPA_PLATFORM = "wayland;xcb";
      };
      systemPackages =
        with pkgs;
        with pkgs.kdePackages;
        [
          # https://github.com/shvedes/awesome-kde
          arianna
          breeze
          ffmpegthumbnailer
          filelight
          haruna
          icoutils
          isoimagewriter
          kaccounts-providers
          kcalc
          kcron
          kdenetwork-filesharing
          kdesu
          kdialog
          kdotool
          kfind
          kget
          kgpg
          kio-fuse
          kirigami-addons
          kjournald
          kmousetool
          kompare
          krfb
          krita
          ksshaskpass
          ksystemlog
          #kzones
          markdownpart
          neochat
          okteta
          orca
          packagekit-qt # Discover store
          qt6.qtwebengine
          qtimageformats
          qtsvg # https://github.com/NixOS/nixpkgs/issues/325225
          sddm-kcm
          svgpart
          syntax-highlighting
          tokodon
        ]
        ++ lib.optionals vars.gaming [
          inputs.rom-properties.packages.${pkgs.stdenv.hostPlatform.system}.rp_kde6
        ];
    };
    nixpkgs.overlays = [
      (final: prev: {
        kdePackages = prev.kdePackages.overrideScope (
          kdeFinal: kdePrev: {
            # https://old.reddit.com/r/NixOS/comments/1pdtc3v/kde_plasma_is_slow_compared_to_any_other_distro/
            # https://github.com/NixOS/nixpkgs/issues/126590#issuecomment-3194531220
            plasma-workspace =
              let
                # the package we want to override
                basePkg = kdePrev.plasma-workspace;
                # a helper package that merges all the XDG_DATA_DIRS into a single directory
                xdgdataPkg = final.stdenv.mkDerivation {
                  name = "${basePkg.name}-xdgdata";
                  buildInputs = [ basePkg ];
                  dontUnpack = true;
                  dontFixup = true;
                  dontWrapQtApps = true;
                  installPhase = ''
                    mkdir -p $out/share
                    ( IFS=:
                      for DIR in $XDG_DATA_DIRS; do 
                        if [[ -d "$DIR" ]]; then
                          ${prev.lib.getExe prev.lndir} -silent "$DIR" $out
                        fi
                      done
                    )
                  '';
                };
                # undo the XDG_DATA_DIRS injection that is usually done in the qt wrapper
                # script and instead inject the path of the above helper package
                derivedPkg = basePkg.overrideAttrs {
                  preFixup = ''
                    for index in "''${!qtWrapperArgs[@]}"; do
                      if [[ ''${qtWrapperArgs[$((index+0))]} == "--prefix" ]] && [[ ''${qtWrapperArgs[$((index+1))]} == "XDG_DATA_DIRS" ]]; then
                        unset -v "qtWrapperArgs[$((index+0))]"
                        unset -v "qtWrapperArgs[$((index+1))]"
                        unset -v "qtWrapperArgs[$((index+2))]"
                        unset -v "qtWrapperArgs[$((index+3))]"
                      fi
                    done
                    qtWrapperArgs=("''${qtWrapperArgs[@]}")
                    qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "${xdgdataPkg}/share")
                    qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "$out/share")
                  '';
                };
              in
              derivedPkg;
          }
        );
      })
    ];
    programs = {
      fuse.userAllowOther = true;
      k3b.enable = true;
      kdeconnect.enable = true;
      kde-pim.enable = true;
      partition-manager.enable = true;
    };
    services = {
      colord.enable = true;
      desktopManager.plasma6.enable = true;
      displayManager = {
        autoLogin = {
          user = "${username}";
        };
        plasma-login-manager = {
          settings = {
            General = {
              InputMethod = ""; # Remove virtual keyboard
            };
            wayland = {
              enable = true;
              compositor = "kwin";
            };
          };
        };
      };
      libinput = {
        mouse.accelProfile = "flat";
        touchpad.accelProfile = "flat";
      };
    };
    xdg.portal = {
      enable = true;
      config = {
        kde = {
          default = [
            "kde"
            "gtk"
          ];
          "org.freedesktop.portal.FileChooser" = [ "kde" ];
          "org.freedesktop.portal.OpenURI" = [ "kde" ];
        };
      };
      extraPortals = with pkgs; [
        kdePackages.xdg-desktop-portal-kde
        xdg-desktop-portal-gtk
      ];
      xdgOpenUsePortal = true;
    };
    home-manager.users.${username} =
      { config, ... }:
      {
        home.file = {
          purposerc = {
            enable = true;
            text = ''
              [plugins]
              disabled=emailplugin,imgurplugin,nextcloudplugin,pastebinplugin,purpose_gdrive,telegramplugin,youtubeplugin
            '';
            target = "${config.xdg.configHome}/purposerc";
          };
        };
      };
  };
}
