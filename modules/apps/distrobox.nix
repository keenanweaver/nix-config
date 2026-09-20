{
  flake.modules.homeManager = {
    profile-base =
      { lib, pkgs, ... }:
      {
        home.packages = with pkgs; [ distrobox-tui ];
        programs.distrobox.enable = lib.mkDefault true;
      };
    profile-desktop =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ kontainer ];
      };
  };
}
