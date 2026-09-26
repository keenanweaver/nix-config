{
  flake.modules = {
    homeManager.profile-gaming =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          (bottles.override {
            removeWarningPopup = true;
          })
        ];
      };
    nixos.profile-gaming.xdg.mime.defaultApplications."x-scheme-handler/bottles" =
      "com.usebottles.bottles.desktop";
  };
}
