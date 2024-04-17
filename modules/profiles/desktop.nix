{ inputs, home-manager, lib, config, pkgs, username, ... }: with lib;
let
  cfg = config.desktop;
in
{
  imports = [
    ./base.nix
  ];

  options = {
    desktop = {
      enable = mkEnableOption "Enable desktop in NixOS";
    };
  };
  config = mkIf cfg.enable {
    # Custom modules
    base.enable = true;
    catppuccinTheming.enable = true;
    hyprland.enable = false;
    kde.enable = true;
    vscode.enable = true;
    wezterm.enable = true;
    xwayland.enable = true;

    environment = {
      systemPackages = with pkgs; [
        alsa-firmware
        alsa-lib
        alsa-plugins
        alsa-tools
        alsa-utils
        xdg-desktop-portal
      ];
    };
    hardware = {
      bluetooth = {
        enable = true;
        settings = {
          General = { Experimental = "true"; }; # https://reddit.com/r/NixOS/comments/1aoteqb/keychron_k1_pro_bluetooth_nixos_wkde_install/kq49q9r/?context=3
        };
      };
      enableAllFirmware = true;
      i2c.enable = true;
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };
    };
    services = {
      devmon.enable = true;
      fwupd.enable = true;
    };

    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      dconf.settings = {
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = [ "qemu:///system" ];
          uris = [ "qemu:///system" ];
        };
      };
      gtk = {
        enable = true;
        gtk2 = {
          configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
        };
      };

      nixpkgs = {
        overlays = [
          inputs.nix-vscode-extensions.overlays.default
        ];
      };

      services = {
        opensnitch-ui.enable = true;
      };

      xdg = {
        enable = true;
        mimeApps = {
          enable = true;
          associations = {
            added = {
              "application/json" = [ "org.kde.kate.desktop" ];
              "application/pdf" = [ "org.kde.okular.desktop" "one.ablaze.floorp.desktop" ];
              "application/toml" = [ "org.kde.kate.desktop" ];
              "application/x-bat" = [ "org.kde.kate.desktop" ];
              "application/x-cue" = [ "cdemu-client.desktop" ];
              "application/x-msdownload" = [ "wine.desktop" ];
              "application/xhtml+xml" = [ "one.ablaze.floorp.desktop" ];
              "application/xml" = [ "org.kde.kate.desktop" ];
              "audio/*" = [ "org.strawberrymusicplayer.strawberry.desktop" ];
              "image/*" = [ "org.kde.gwenview.desktop" ];
              "inode/directory" = [ "org.kde.dolphin.desktop" ];
              "text/*" = [ "org.kde.kate.desktop" "Helix.desktop" "micro.desktop" "nvim.desktop" ];
              "text/html" = [ "one.ablaze.floorp.desktop" "com.vivaldi.Vivaldi.desktop" "net.mullvad.MullvadBrowser.desktop" "org.kde.kate.desktop" ];
              "video/*" = [ "org.kde.haruna.desktop" ];
              "x-scheme-handler/bottles" = [ "com.usebottles.bottles.desktop" ];
              "x-scheme-handler/http" = [ "one.ablaze.floorp.desktop" ];
              "x-scheme-handler/https" = [ "one.ablaze.floorp.desktop" ];
            };
            removed = { };
          };
          defaultApplications = {
            "application/x-cue" = [ "cdemu-client.desktop" ];
            "application/x-msdownload" = [ "wine.desktop" ];
            "audio/aac" = [ "org.strawberrymusicplayer.strawberry.desktop" ];
            "audio/flac" = [ "org.strawberrymusicplayer.strawberry.desktop" ];
            "audio/mpeg" = [ "org.strawberrymusicplayer.strawberry.desktop" ];
            "audio/ogg" = [ "org.strawberrymusicplayer.strawberry.desktop" ];
            "audio/webm" = [ "org.kde.haruna.desktop" ];
            "image/bmp" = [ "org.kde.gwenview.desktop" ];
            "image/gif" = [ "org.kde.gwenview.desktop" ];
            "image/jpeg" = [ "org.kde.gwenview.desktop" ];
            "image/png" = [ "org.kde.gwenview.desktop" ];
            "image/webp" = [ "org.kde.gwenview.desktop" ];
            "text/html" = [ "one.ablaze.floorp.desktop" ];
            "text/plain" = [ "org.kde.kate.desktop" ];
            "video/mp4" = [ "org.kde.haruna.desktop" ];
            "video/mpeg" = [ "org.kde.haruna.desktop" ];
            "video/quicktime" = [ "org.kde.haruna.desktop" ];
            "video/webm" = [ "org.kde.haruna.desktop" ];
            "video/x-flv" = [ "org.kde.haruna.desktop" ];
            "video/x-matroska" = [ "org.kde.haruna.desktop" ];
            "video/x-ms-wmv" = [ "org.kde.haruna.desktop" ];
            "x-scheme-handler/bottles" = [ "com.usebottles.bottles.desktop" ];
            "x-scheme-handler/http" = [ "one.ablaze.floorp.desktop" ];
            "x-scheme-handler/https" = [ "one.ablaze.floorp.desktop" ];
            "x-scheme-handler/ror2mm" = [ "r2modman.desktop" ];
          };
        };
        portal = {
          config.common.default = "*";
          enable = true;
          extraPortals = with pkgs; [ kdePackages.xdg-desktop-portal-kde xdg-desktop-portal-gtk ];
        };
      };
    };
  };
}
