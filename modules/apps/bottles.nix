{
  flake.modules.homeManager.profile-gaming =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        (bottles.override {
          removeWarningPopup = true;
        })
      ];
    };
}
