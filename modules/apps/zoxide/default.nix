{ lib, config, username, ... }:
let
  cfg = config.zoxide;
in
{
  options = {
    zoxide = {
      enable = lib.mkEnableOption "Enable zoxide in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.zoxide.enable = true;
    };
  };
}
