{
  flake.modules = {
    homeManager.profile-desktop =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          gearlever
          libnotify
          qpwgraph
          rustdesk-flutter
        ];
      };
    nixos.profile-desktop =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          lm_sensors
          pciutils
          xdg-user-dirs
        ];
      };
  };
}
