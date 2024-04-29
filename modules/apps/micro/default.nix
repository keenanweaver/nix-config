{ lib, config, username, ... }:
let
  cfg = config.micro;
in
{
  options = {
    micro = {
      enable = lib.mkEnableOption "Enable micro in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
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
