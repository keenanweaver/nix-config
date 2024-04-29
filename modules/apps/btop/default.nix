{ lib, config, username, ... }:
let
  cfg = config.btop;
in
{
  options = {
    btop = {
      enable = lib.mkEnableOption "Enable btop in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.btop.enable = true;
    };
  };
}
