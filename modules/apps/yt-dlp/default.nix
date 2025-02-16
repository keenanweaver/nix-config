{
  lib,
  config,
  username,
  inputs,
  ...
}:
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
    home-manager.users.${username} =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ media-downloader ];
        programs.yt-dlp = {
          enable = true;
          package = inputs.chaotic.packages.${pkgs.system}.yt-dlp_git;
        };
      };
  };
}
