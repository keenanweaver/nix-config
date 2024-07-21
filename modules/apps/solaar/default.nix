{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.solaar;
in
{
  options = {
    solaar = {
      enable = lib.mkEnableOption "Enable solaar in home-manager";
    };
  };
  config = lib.mkIf cfg.enable {

    hardware.logitech = {
      wireless = {
        enable = true;
        enableGraphical = true;
      };
    };

    home-manager.users.${username} =
      { config, ... }:
      {
        home.file = {
          autostart-solaar = {
            enable = true;
            text = ''
              [Desktop Entry]
              Exec=solaar --window=hide
              Icon=solaar
              Name=solaar
              Terminal=false
              Type=Application
            '';
            target = "${config.xdg.configHome}/autostart/solaar.desktop";
            executable = true;
          };
        };
      };
  };
}
