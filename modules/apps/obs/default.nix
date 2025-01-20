{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.obs;
in
{
  options = {
    obs = {
      enable = lib.mkEnableOption "Enable obs in home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      home = {
        packages = with pkgs; [
          obs-cmd
        ];
        sessionVariables = {
          OBS_VKCAPTURE_QUIET = "1";
        };
      };
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          input-overlay
          looking-glass-obs
          obs-gstreamer
          obs-pipewire-audio-capture
          obs-vaapi
          obs-vkcapture
        ];
      };
      xdg = {
        desktopEntries = {
          "obs" = {
            name = "OBS Studio";
            comment = "Free and Open Source Streaming/Recording Software";
            exec = "obs --disable-shutdown-check";
            terminal = false;
            icon = "com.obsproject.Studio";
            type = "Application";
            startupNotify = true;
            categories = [
              "AudioVideo"
              "Recorder"
            ];
          };
        };
      };
    };
  };
}
