{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.nh;
in
{
  options = {
    nh = {
      enable = lib.mkEnableOption "Enable nh in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.nh = {
      enable = true;
      flake = "/mnt/crusader/Projects/GitHub/nix-config";
    };
    home-manager.users.${username} = { };
  };
}
