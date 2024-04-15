{ inputs, home-manager, lib, config, username,  ... }: with lib;
let
  cfg = config.micro;
in
{
  options = {
    micro = {
      enable = mkEnableOption "Enable micro in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      programs.micro = {
        enable = true;
        settings = {
          autosu = true;
          softwrap = true;
          wordwrap = true;
        };
      };
    };
  };
}
