{ inputs, home-manager, lib, config, username,  ... }: with lib;
let
  cfg = config.foot;
in
{
  options = {
    foot = {
      enable = mkEnableOption "Enable foot in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
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
