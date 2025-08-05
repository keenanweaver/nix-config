{
  lib,
  config,
  username,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.jujutsu;
in
{
  options = {
    jujutsu = {
      enable = lib.mkEnableOption "Enable jujutsu in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        lazyjj
      ];
      programs.jujutsu = {
        enable = true;
        package = inputs.chaotic.packages.${pkgs.system}.jujutsu_git;
      };
    };
  };
}
