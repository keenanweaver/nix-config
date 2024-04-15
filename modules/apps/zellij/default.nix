{ inputs, home-manager, lib, config, username,  ... }: with lib;
let
  cfg = config.zellij;
in
{
  options = {
    zellij = {
      enable = mkEnableOption "Enable zellij in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      programs.zellij = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };
    };
  };
}
