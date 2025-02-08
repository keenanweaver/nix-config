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
      home.packages = with pkgs; [
        (lazyjj.overrideAttrs {
          version = "0.4.3-unstable-2025-01-04";
          src = fetchFromGitHub {
            owner = "misaelaguayo";
            repo = "lazyjj";
            rev = "update-snapshots-jj25";
            hash = "sha256-XRPDs4TwoDgOypLfv5H4V8YdD04Em8xJ3l+ALRngihQ=";
          };
        })
      ];
      programs.jujutsu = {
        enable = true;
      };
    };
  };
}
