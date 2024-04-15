{ inputs, home-manager, lib, config, username,  ... }: with lib;
let
  cfg = config.zoxide;
in
{
  options = {
    zoxide = {
      enable = mkEnableOption "Enable zoxide in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      programs.zoxide.enable = true;
    };
  };
}
