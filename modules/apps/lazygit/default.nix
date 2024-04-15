{ inputs, home-manager, lib, config, username,  ... }: with lib;
let
  cfg = config.lazygit;
in
{
  options = {
    lazygit = {
      enable = mkEnableOption "Enable lazygit in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      programs.lazygit.enable = true;
    };
  };
}
