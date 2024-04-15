{ inputs, home-manager, lib, config, username,  ... }: with lib;
let
  cfg = config.yt-dlp;
in
{
  options = {
    yt-dlp = {
      enable = mkEnableOption "Enable yt-dlp in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      programs.yt-dlp = with pkgs; {
        enable = true;
        package = yt-dlp_git; # Chaotic Nyx package
      };
    };
  };
}
