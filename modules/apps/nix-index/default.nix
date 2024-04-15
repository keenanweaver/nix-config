{ inputs, home-manager, lib, config, username,  ... }: with lib;
let
  cfg = config.nix-index;
in
{
  options = {
    nix-index = {
      enable = mkEnableOption "Enable nix-index in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      programs.nix-index.enable = true;
    };
  };
}
