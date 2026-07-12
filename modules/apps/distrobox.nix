{
  flake.modules = {
    homeManager = {
      base-profile = { pkgs, ... }: {
        home.packages = with pkgs; [ distrobox-tui ];
        programs.distrobox.enable = true;
      };
      desktop-profile = { pkgs, ... }: {
        home.packages = with pkgs; [ kontainer ];
      };
    };
  };
}
