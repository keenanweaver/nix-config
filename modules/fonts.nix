{
  flake.modules.nixos.base-profile = { pkgs, ... }: {
    environment = {
      sessionVariables = {
        # https://www.reddit.com/r/linux_gaming/comments/16lwgnj/comment/k1536zb/?utm_source=reddit&utm_medium=web2x&context=3
        FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";
        # https://reddit.com/r/kde/comments/1bjgajv/fractional_scaling_still_seems_to_look_worse_than/kvshkoz/?context=3
        QT_SCALE_FACTOR_ROUNDING_POLICY = "RoundPreferFloor";
      };
    };
    fonts = {
      fontDir = {
        enable = true;
      };
      fontconfig = {
        allowBitmaps = false;
        defaultFonts = {
          monospace = [
            "Maple Mono Normal NF"
            "Liberation Mono"
          ];
          sansSerif = [
            "Inter"
            "Liberation Sans"
          ];
          serif = [
            "Liberation Serif"
          ];
        };
        subpixel.rgba = "rgb";
      };
      packages = with pkgs; [
        inter
        liberation_ttf
        maple-mono.Normal-NF
        material-design-icons
        source-han-sans
        wqy_zenhei
      ];
    };
  };
}
