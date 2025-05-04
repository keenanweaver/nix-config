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
      { pkgs, ... }:
      {
        xdg.autostart.entries = lib.mkIf cfg.autostart [
          "${pkgs.solaar}/share/applications/solaar.desktop"
        ];
      };
  };
}
