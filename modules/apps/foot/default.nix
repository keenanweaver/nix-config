{ lib, config, username, ... }:
let
  cfg = config.foot;
in
{
  options = {
    foot = {
      enable = lib.mkEnableOption "Enable foot in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.foot = {
        enable = true;
        settings = {
          main = {
            dpi-aware = "yes";
          };
        };
      };
    };
  };
}
