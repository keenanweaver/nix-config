{
  lib,
  inputs,
  pkgs,
  config,
  username,
  ...
}:
let
  cfg = config.niri;
in
{
  options = {
    niri = {
      enable = lib.mkEnableOption "Enable niri in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.niri.overlays.niri ];
    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };
    home-manager.users.${username} = { };
  };
}
