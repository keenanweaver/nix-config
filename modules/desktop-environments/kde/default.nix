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
        XDG_CURRENT_DESKTOP = "KDE";
      };
      systemPackages =
        with pkgs;
        with pkgs.kdePackages;
        [
          # https://github.com/shvedes/awesome-kde
          akregator
          arianna
          breeze
          ffmpegthumbnailer
          filelight
          haruna
          icoutils
          isoimagewriter
          k3b
          kaccounts-providers
          kcalc
          kcron
          kdenetwork-filesharing
          kdesu
          kdialog
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
    # TODO: Remove after Plasma fixed favorites reloading https://github.com/NixOS/nixpkgs/issues/414909
    system.userActivationScripts = {
      "restart-plasma" = ''
        ${pkgs.systemd}/bin/systemctl restart --user plasma-plasmashell.service
      '';
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
    home-manager.users.${username} = {
      xdg.autostart.entries =
        let
          akregator = (
            pkgs.makeDesktopItem {
              name = "akregator";
              desktopName = "akregator";
              exec = "akregator %u --hide-mainwindow";
              comment = "Run akregator";
              terminal = false;
              startupNotify = false;
            }
          );
        in
        [
          "${akregator}/share/applications/${akregator.name}"
        ];
    };
  };
}
