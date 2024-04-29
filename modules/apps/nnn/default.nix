{ lib, config, username, ... }:
let
  cfg = config.nnn;
in
{
  options = {
    nnn = {
      enable = lib.mkEnableOption "Enable nnn in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = { pkgs, ... }: {
      programs.nnn = {
        enable = true;
        package = pkgs.nnn.override { withNerdIcons = true; };
      };
    };
  };
}
