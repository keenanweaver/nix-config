{ inputs, home-manager, lib, config, pkgs, username, ... }: with lib;
let
  cfg = config.kde;
in
{
  imports = [
    ./plasma-manager/desktop.nix
  ];

  options = {
    kde = {
      enable = mkEnableOption "Enable kde in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    environment = {
      plasma6.excludePackages = with pkgs.kdePackages; [ elisa kwrited ];
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
        kate
        kcalc
        kcron
        kdesu
        kdialog
        kio-extras
        kirigami-addons
        inputs.kwin-effects-forceblur.packages.${pkgs.system}.default
        packagekit-qt # Discover store
        plasma-browser-integration
        qtimageformats
        qtstyleplugin-kvantum
        sddm-kcm
        syntax-highlighting
      ];
    };
    programs = {
      fuse = { userAllowOther = true; };
      kdeconnect = with pkgs; {
        enable = true;
      };
      partition-manager.enable = true;
    };
    services = {
      colord.enable = true;
      desktopManager = { plasma6.enable = true; };
      displayManager = {
        autoLogin = { user = "${username}"; };
        defaultSession = "plasmax11";
        sddm = {
          enable = true;
          settings = {
            General = {
              InputMethod = ""; # Remove virtual keyboard
            };
            wayland.enable = true;
          };
        };
      };
      xserver = {
        displayManager.setupCommands = ''
          ${pkgs.xorg.xhost}/bin/xhost +local:
        ''; # Distrobox games
        enable = true;
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
        xdgOpenUsePortal = true;
      };
    };
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      services = {
        kdeconnect.enable = true;
      };
    };
  };
}
