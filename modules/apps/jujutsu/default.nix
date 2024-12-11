{
  lib,
  config,
  username,
  pkgs,
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
      home.packages = with pkgs; [ lazyjj ];
      programs.jujutsu = {
        enable = true;
      };
    };
  };
}
