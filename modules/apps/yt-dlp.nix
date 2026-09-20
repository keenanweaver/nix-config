{ lib, ... }:
{
  flake.modules.homeManager.profile-base.programs.yt-dlp.enable = lib.mkDefault true;
}
