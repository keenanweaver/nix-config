{
  inputs,
  lib,
  config,
  pkgs,
  username,
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
        XDG_CURRENT_DESKTOP = "KDE";
      };
      systemPackages =
        with pkgs;
        with pkgs.kdePackages;
        [
          akregator
          ffmpegthumbnailer
          filelight
          haruna
          kcalc
          kcron
          kdesu
          kdialog
          kirigami-addons
          kjournald
          krita
          inputs.kwin-effects-forceblur.packages.${pkgs.system}.default
          isoimagewriter
          neochat
          okteta
          packagekit-qt # Discover store
          qt6.qtwebengine
          qtimageformats
          qtsvg # https://github.com/NixOS/nixpkgs/issues/325225
          sddm-kcm
          syntax-highlighting
          tokodon
        ];
    };
    # Neochat
    nixpkgs.config.permittedInsecurePackages = [
      "olm-3.2.16"
    ];
    programs = {
      fuse.userAllowOther = true;
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
    xdg = {
      portal = {
        config.common.default = "*";
        extraPortals = with pkgs; [
          kdePackages.xdg-desktop-portal-kde
          xdg-desktop-portal-gtk
        ];
        xdgOpenUsePortal = true;
      };
    };
    home-manager.users.${username} =
      { config, ... }:
      {
        home.file = {
          desktop-entry-akregator = {
            enable = true;
            text = ''
              [Desktop Entry]
              Exec=akregator %u --hide-mainwindow
              Name=akregator
              Type=Application
            '';
            target = "${config.xdg.configHome}/autostart/akregator.desktop";
          };
        };
        services.kdeconnect = {
          enable = true;
          package = pkgs.kdePackages.kdeconnect-kde;
        };
      };
  };
}
