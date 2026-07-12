{
  flake.modules = {
    homeManager.solaar = { pkgs, ... }: {
      home.packages = with pkgs; [ solaar ];
      /*
        xdg.autostart.entries = with pkgs; [
             "${solaar}/share/applications/solaar.desktop"
           ];
      */
    };
    nixos.solaar = {
      hardware.logitech = {
        wireless = {
          enable = true;
          enableGraphical = true;
        };
      };
    };
  };
}
