{ inputs, home-manager, lib, config, username,  ... }: with lib;
let
  cfg = config.ripgrep;
in
{
  options = {
    ripgrep = {
      enable = mkEnableOption "Enable ripgrep in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      programs.ripgrep = {
        enable = true;
        arguments = [ "-uuu" ];
      };
    };
  };
}
