{
  lib,
  config,
  username,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.fluxer;
in
{
  options = {
    fluxer = {
      enable = lib.mkEnableOption "Enable fluxer in home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        inputs.nix-gaming-edge.packages.${stdenv.hostPlatform.system}.fluxer-desktop
      ];
    };
  };
}
