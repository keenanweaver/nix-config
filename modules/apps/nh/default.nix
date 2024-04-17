{ inputs, home-manager, lib, config, username, ... }: with lib;
let
  cfg = config.nh;
in
{
  options = {
    nh = {
      enable = mkEnableOption "Enable nh in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    programs.nh = {
      enable = true;
      flake = "/mnt/crusader/Projects/GitHub/nix-config";
    };
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: { };
  };
}
