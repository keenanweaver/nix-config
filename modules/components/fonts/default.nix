{
  lib,
  config,
  pkgs,
  username,
  vars,
  ...
}:
let
  cfg = config.fonts;
in
{
  options = {
    fonts = {
      enable = lib.mkEnableOption "Enable fonts in NixOS or home-manager";
    };
  };

  config = lib.mkIf cfg.enable {
    fonts = {
      enableDefaultPackages = false;
      fontDir = {
        enable = true;
        decompressFonts = true;
      };
      packages = with pkgs; [
        apple-fonts
        b612
        caladea
        carlito
        corefonts
        font-awesome
        ibm-plex
        lexend
        liberation_ttf
        (nerdfonts.override {
          fonts = [
            "FiraCode"
            "FiraMono"
            "IBMPlexMono"
            "Iosevka"
            "IosevkaTerm"
            "JetBrainsMono"
          ];
        })
        material-design-icons
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        source-han-sans
        source-han-sans-japanese
        source-han-serif-japanese
        ubuntu_font_family
      ];
      fontconfig = {
        allowBitmaps = false;
        defaultFonts = {
          monospace = [
            "JetBrainsMono Nerd Font"
            "BlexMono Nerd Font"
            "Noto Color Emoji"
          ];
          sansSerif = [
            "IBM Plex Sans"
            "Noto Color Emoji"
          ];
          serif = [
            "IBM Plex Serif"
            "Noto Color Emoji"
          ];
          emoji = [ "Noto Color Emoji" ];
        };
        hinting = {
          enable = true;
          style = "slight";
        };
        subpixel.rgba = "rgb";
      };
    };
    environment = {
      sessionVariables = {
        #https://www.reddit.com/r/linux_gaming/comments/16lwgnj/comment/k1536zb/?utm_source=reddit&utm_medium=web2x&context=3
        FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";
        # https://reddit.com/r/kde/comments/1bjgajv/fractional_scaling_still_seems_to_look_worse_than/kvshkoz/?context=3
        QT_SCALE_FACTOR_ROUNDING_POLICY = "RoundPreferFloor";
      };
    };
    home-manager.users.${username} =
      { inputs, config, ... }:
      {
        home.file = {
          windows-fonts = {
            enable = true;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${inputs.nonfree}/.local/share/fonts/windows";
            target = "${config.xdg.dataHome}/fonts/windows";
          };
        };
      };
  };
}
