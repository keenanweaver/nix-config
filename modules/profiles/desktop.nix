{
  lib,
  config,
  pkgs,
  username,
  ...
}:
let
  cfg = config.desktop;
in
{
  imports = [ ./base.nix ];

  options = {
    desktop = {
      enable = lib.mkEnableOption "Enable desktop in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    # Custom modules
    base.enable = true;
    catppuccinTheming.enable = true;
    hyprland.enable = false;
    kde.enable = true;
    mumble.enable = true;
    vscode.enable = true;
    wezterm.enable = true;
    wireshark.enable = true;
    xwayland.enable = true;

    environment = {
      systemPackages = with pkgs; [
        apostrophe
        xdg-desktop-portal
      ];
    };
    hardware = {
      bluetooth = {
        enable = true;
        settings = {
          General = {
            Experimental = "true";
          }; # https://reddit.com/r/NixOS/comments/1aoteqb/keychron_k1_pro_bluetooth_nixos_wkde_install/kq49q9r/?context=3
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
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    services = {
      devmon.enable = true;
      fwupd.enable = true;
    };

    home-manager.users.${username} =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          (fooyin.overrideAttrs (attrs: {
            version = "0.4.3";
            src = fetchFromGitHub {
              owner = "ludouzi";
              repo = "fooyin";
              rev = "v0.4.3";
              hash = "sha256-S74Y7Q3MmKfxMGyO8un+YDHmCJUYNKY6KqTSPn+CynE=";
            };
          }))
          neo
        ];

        xdg = {
          enable = true;
          mimeApps = {
            enable = true;
            associations = {
              added = {
                "application/json" = [ "org.kde.kate.desktop" ];
                "application/pdf" = [
                  "org.kde.okular.desktop"
                  "one.ablaze.floorp.desktop"
                ];
                "application/toml" = [ "org.kde.kate.desktop" ];
                "application/x-bat" = [ "org.kde.kate.desktop" ];
                "application/x-cue" = [ "cdemu-client.desktop" ];
                "application/x-msdownload" = [ "wine.desktop" ];
                "application/xhtml+xml" = [ "one.ablaze.floorp.desktop" ];
                "application/xml" = [ "org.kde.kate.desktop" ];
                "audio/*" = [ "org.strawberrymusicplayer.strawberry.desktop" ];
                "image/*" = [ "org.kde.gwenview.desktop" ];
                "inode/directory" = [ "org.kde.dolphin.desktop" ];
                "text/*" = [
                  "org.kde.kate.desktop"
                  "Helix.desktop"
                  "micro.desktop"
                  "nvim.desktop"
                ];
                "text/html" = [
                  "one.ablaze.floorp.desktop"
                  "com.vivaldi.Vivaldi.desktop"
                  "net.mullvad.MullvadBrowser.desktop"
                  "org.kde.kate.desktop"
                ];
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
            extraPortals = with pkgs; [
              kdePackages.xdg-desktop-portal-kde
              xdg-desktop-portal-gtk
            ];
          };
        };
      };
  };
}
