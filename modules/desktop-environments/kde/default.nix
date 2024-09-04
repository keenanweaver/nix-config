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
      systemPackages = with pkgs.kdePackages; [
        colord-kde
        discover
        ffmpegthumbnailer
        filelight
        kcalc
        kcron
        kdesu
        kdialog
        kio-extras
        kirigami-addons
        kjournald
        ksshaskpass
        inputs.kwin-effects-forceblur.packages.${pkgs.system}.default
        isoimagewriter
        packagekit-qt # Discover store
        plasma-browser-integration
        qtimageformats
        qtsvg # https://github.com/NixOS/nixpkgs/issues/325225
        sddm-kcm
        syntax-highlighting
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
      /*
        xserver = {
             xkb = {
               layout = "mine,us";
               # https://github.com/nagy/dotfiles/blob/bbc152df487086aa6fea10c69ad9341831f1595a/modules/desktop.nix#L17
               # https://reddit.com/r/linux_gaming/comments/1cvxws3/i_got_f13_to_work_on_nobara/
               extraLayouts = {
                 mine = {
                   description = "Restore original keys for F13-24";
                   languages = [ "eng" ];
                   symbolsFile = pkgs.writeText "myinclude.conf" ''
                     default partial function_keys
                     xkb_symbols "restore_fk" {
                         key<FK13> { [ F13 ] };
                         key<FK14> { [ F14 ] };
                         key<FK15> { [ F15 ] };
                         key<FK16> { [ F16 ] };
                         key<FK17> { [ F17 ] };
                         key<FK18> { [ F18 ] };
                         key<FK19> { [ F19 ] };
                         key<FK20> { [ F20 ] };
                         key<FK21> { [ F21 ] };
                         key<FK22> { [ F22 ] };
                         key<FK23> { [ F23 ] };
                         key<FK24> { [ F24 ] };
                     };
                   '';
                 };
               };
             };
           };
      */
    };
    # https://github.com/NixOS/nixpkgs/issues/305119#issuecomment-2067970575
    #systemd.user.services.nixos-rebuild-sycoca.enable = false;
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
      services.kdeconnect = {
        enable = true;
        package = pkgs.kdePackages.kdeconnect-kde;
      };
    };
  };
}
