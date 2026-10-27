{ lib, ... }:
let
  accent-lower = "lavender";
  capitalize = s: lib.toUpper (lib.substring 0 1 s) + lib.substring 1 (-1) s;
  flavor-accent = "${flavor-lower}-${accent-lower}";
  flavor-lower = "mocha";
in
{
  theme = {
    inherit accent-lower flavor-accent flavor-lower;
    GTK-THEME = "Breeze-Dark";
    accent-upper = capitalize accent-lower;
    cursor-theme = "catppuccin-${flavor-accent}-cursors";
    flavor-upper = capitalize flavor-lower;
    icon-theme = "Papirus-Dark";
    mono-font = "Maple Mono Normal NF";
    mono-size = 14;
    sans-font = "Inter";
    wallpaper = "${../../assets/theming/wallpapers/puffy-stars.jpg}";
    wallpaper-secondary = "${../../assets/theming/wallpapers/dark-waves.jpg}";
  };
}
