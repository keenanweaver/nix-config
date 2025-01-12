{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.vhs-decode;
in
{
  options = {
    vhs-decode = {
      enable = lib.mkEnableOption "Enable vhs-decode in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [ nur.repos.jitterbug.vhs-decode ];
    };
  };
}
