let
  accent-lower = "lavender";
  accent-upper = "Lavender";
  flavor-accent = "${flavor-lower}-${accent-lower}";
  flavor-lower = "mocha";
  flavor-upper = "Mocha";
  mono-font = "Maple Mono Normal NF";
  mono-size = 14;
in
{
  flake.lib = {
    fonts.monospace = {
      family = mono-font;
      size = mono-size;
    };
    theme = {
      inherit
        accent-lower
        accent-upper
        flavor-accent
        flavor-lower
        flavor-upper
        mono-font
        mono-size
        ;
      GTK-THEME = "Breeze-Dark";
      cursor-theme = "catppuccin-${flavor-accent}-cursors";
      icon-theme = "Papirus-Dark";
      sans-font = "Inter";
      wallpaper = "${../../assets/theming/wallpapers/puffy-stars.jpg}";
      wallpaper-secondary = "${../../assets/theming/wallpapers/dark-waves.jpg}";
    };
  };
}
