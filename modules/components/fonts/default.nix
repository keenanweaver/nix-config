{
  lib,
  config,
  pkgs,
  username,
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
      fontDir = {
        enable = true;
      };
      packages = with pkgs; [
        adwaita-fonts
        corefonts
        geist-font
        liberation_ttf
        material-design-icons
        nerd-fonts.jetbrains-mono
        source-han-sans
        source-han-sans-japanese
        source-han-serif-japanese
        ubuntu-sans
        wqy_zenhei
      ];
      fontconfig = {
        allowBitmaps = false;
        defaultFonts = {
          monospace = [
            "JetBrainsMono Nerd Font"
            "Liberation Mono"
          ];
          sansSerif = [
            "Adwaita Sans"
            "Liberation Sans"
          ];
          serif = [
            "Liberation Serif"
            "Adwaita Sans"
          ];
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
    home-manager.users.${username} = { };
  };
}
