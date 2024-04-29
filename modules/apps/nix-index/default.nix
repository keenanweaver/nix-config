{ lib, config, username, ... }:
let
  cfg = config.nix-index;
in
{
  options = {
    nix-index = {
      enable = lib.mkEnableOption "Enable nix-index in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.nix-index.enable = true;
    };
  };
}
