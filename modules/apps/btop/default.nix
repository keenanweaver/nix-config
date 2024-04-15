{ inputs, home-manager, lib, config, username,  ... }: with lib;
let
  cfg = config.btop;
in
{
  options = {
    btop = {
      enable = mkEnableOption "Enable btop in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      programs.btop.enable = true;
    };
  };
}
