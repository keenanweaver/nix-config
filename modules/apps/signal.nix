{
  flake.modules = {
    homeManager.profile-workstation =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ signal-desktop ];
      };
    nixos.profile-workstation.xdg.mime.defaultApplications = {
      "x-scheme-handler/sgnl" = "signal.desktop";
      "x-scheme-handler/signalcaptcha" = "signal.desktop";
    };
  };
}
