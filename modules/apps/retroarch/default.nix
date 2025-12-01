{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.retroarch;
in
{
  options = {
    retroarch = {
      enable = lib.mkEnableOption "Enable retroarch in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.retroarch = {
        enable = true;
        cores = {
          beetle-psx-hw.enable = true;
          beetle-saturn.enable = true;
          blastem.enable = true;
          mgba.enable = true;
        };
        settings = {
          video_driver = "vulkan";
          video_fullscreen = "true";
          video_smooth = "false";
        };
      };
    };
  };
}
