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
      enable = lib.mkEnableOption "Enable nh in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 14d --keep 3 --optimise";
      };
      flake = "/mnt/crusader/Projects/Codeberg/nix-config";
    };
    home-manager.users.${username} = { };
  };
}
