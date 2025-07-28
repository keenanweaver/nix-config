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
        QT_QPA_PLATFORM = "wayland;xcb";
        XDG_CURRENT_DESKTOP = "KDE";
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
          kzones
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
          systemdgenie
          tokodon
        ]
        ++ lib.optionals vars.gaming [
          inputs.rom-properties.packages.${pkgs.system}.rp_kde6
        ];
    };
    programs = {
      fuse.userAllowOther = true;
      k3b.enable = true;
      kdeconnect.enable = true;
      partition-manager.enable = true;
    };
    services = {
      colord.enable = true;
      desktopManager.plasma6.enable = true;
      displayManager = {
        autoLogin = {
          user = "${username}";
        };
        sddm = {
          enable = true;
          settings = {
            General = {
              InputMethod = ""; # Remove virtual keyboard
            };
          };
          wayland = {
            enable = true;
            compositor = "kwin";
          };
        };
      };
      libinput = {
        mouse.accelProfile = "flat";
        touchpad.accelProfile = "flat";
      };
    };
    xdg.portal = {
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
    home-manager.users.${username} = { };
  };
}
