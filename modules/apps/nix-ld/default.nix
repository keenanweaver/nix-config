{ lib, config, username, ... }:
let
  cfg = config.nix-ld;
in
{
  options = {
    nix-ld = {
      enable = lib.mkEnableOption "Enable nix-ld in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.nix-ld = {
      enable = true;
    };
    home-manager.users.${username} = { };
  };
}
