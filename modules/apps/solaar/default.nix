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
      autostart = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
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
            enable = cfg.autostart;
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
