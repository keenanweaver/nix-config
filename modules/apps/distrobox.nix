{
  flake.modules.homeManager = {
    profile-base =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ distrobox-tui ];
        programs.distrobox.enable = true;
      };
    profile-desktop =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ kontainer ];
      };
  };
}
