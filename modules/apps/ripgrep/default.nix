{ lib, config, username, ... }:
let
  cfg = config.ripgrep;
in
{
  options = {
    ripgrep = {
      enable = lib.mkEnableOption "Enable ripgrep in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.ripgrep = {
        enable = true;
        arguments = [ "-uuu" ];
      };
    };
  };
}
