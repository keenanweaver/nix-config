{
  flake.modules = {
    homeManager.profile-gaming =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ bottles ];
      };
    nixos.profile-gaming.xdg.mime.defaultApplications."x-scheme-handler/bottles" =
      "com.usebottles.bottles.desktop";
  };
}
