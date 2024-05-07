{ inputs, lib, config, pkgs, username, ... }:
let
  cfg = config.kde;
in
{

  imports = [
    ./plasma-manager/desktop.nix
  ];

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
      systemPackages = with pkgs; with pkgs.kdePackages; [
        ffmpegthumbnailer
        colord-kde
        discover
        filelight
        ghostwriter
        k3b
        kate
        kcalc
        kcron
        kdesu
        kdialog
        kio-extras
        kirigami-addons
        kjournald
        inputs.kwin-effects-forceblur.packages.${pkgs.system}.default
        neochat
        packagekit-qt # Discover store
        plasma-browser-integration
        qtimageformats
        qtstyleplugin-kvantum
        sddm-kcm
        syntax-highlighting
        tokodon
      ];
    };
    programs = {
      fuse.userAllowOther = true;
      kdeconnect.enable = true;
      partition-manager.enable = true;
    };
    services = {
      colord.enable = true;
      desktopManager.plasma6.enable = true;
      displayManager = {
        # Black screen on login if enabled with Wayland. https://github.com/NixOS/nixpkgs/issues/292980#issuecomment-1975380961
        #autoLogin = { user = "${username}"; };
        #defaultSession = "plasmax11";
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
      xserver = {
        enable = true;
        displayManager.setupCommands = ''
          ${pkgs.xorg.xhost}/bin/xhost +local:
        ''; # Distrobox games
        excludePackages = with pkgs; [ xterm ];
        libinput = {
          mouse.accelProfile = "flat";
          touchpad.accelProfile = "flat";
        };
        xkb = {
          layout = "us";
        };
      };
    };
    # https://github.com/NixOS/nixpkgs/issues/305119#issuecomment-2067970575
    systemd.user.services.nixos-rebuild-sycoca.enable = false;
    xdg = {
      portal = {
        config.common.default = "*";
        extraPortals = with pkgs; [ kdePackages.xdg-desktop-portal-kde xdg-desktop-portal-gtk ];
        wlr.enable = true;
        xdgOpenUsePortal = true;
      };
    };
    home-manager.users.${username} = {
      services.kdeconnect = {
        enable = true;
        package = pkgs.kdePackages.kdeconnect-kde;
      };
    };
  };
}
