{ lib, config, username, ... }:
let
  cfg = config.yt-dlp;
in
{
  options = {
    yt-dlp = {
      enable = lib.mkEnableOption "Enable yt-dlp in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = { pkgs, ... }: {
      programs.yt-dlp = {
        enable = true;
        package = pkgs.yt-dlp_git; # Chaotic Nyx package
      };
    };
  };
}
