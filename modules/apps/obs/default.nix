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
      enableFlatpak = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      enableNative = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      silenceOutput = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    boot = {
      extraModulePackages = with config.boot.kernelPackages; [
        v4l2loopback
      ];
      kernelModules = [ "v4l2loopback" ];
      extraModprobeConfig = ''
        options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
      '';
    };
    home-manager.users.${username} = {
      home = {
        packages =
          with pkgs;
          lib.mkIf cfg.enableNative [
            obs-cmd
          ];
        sessionVariables = {
          # https://github.com/nowrep/obs-vkcapture/issues/14#issuecomment-3222379615
          VK_INSTANCE_LAYERS = "VK_LAYER_MANGOHUD_overlay_x86:VK_LAYER_MANGOHUD_overlay_x86_64:VK_LAYER_OBS_vkcapture_32:VK_LAYER_OBS_vkcapture_64";
        }
        // lib.optionalAttrs cfg.silenceOutput {
          OBS_VKCAPTURE_QUIET = "1";
        };
      };
      programs.obs-studio = {
        enable = cfg.enableNative;
        plugins = with pkgs.obs-studio-plugins; [
          input-overlay
          obs-gstreamer
          obs-pipewire-audio-capture
          obs-vkcapture
        ];
      };
      services.flatpak = {
        overrides = lib.mkIf cfg.enableFlatpak {
          "com.obsproject.Studio" = {
            Context = {
              sockets = [
                "!wayland" # Disable Wayland so it shows Twitch panels / mouse cursor capture in games
              ];
            };
          };
        };
        packages = [
          "org.freedesktop.Platform.VulkanLayer.OBSVkCapture/x86_64/23.08" # Heroic
          "org.freedesktop.Platform.VulkanLayer.OBSVkCapture/x86_64/24.08"
          "org.freedesktop.Platform.VulkanLayer.OBSVkCapture/x86_64/25.08"
        ]
        ++ lib.optionals cfg.enableFlatpak [
          "com.obsproject.Studio"
          "com.obsproject.Studio.Plugin.InputOverlay"
          "com.obsproject.Studio.Plugin.OBSVkCapture"
        ];
      };
      xdg = {
        desktopEntries = {
          "com.obsproject.Studio" = lib.mkIf cfg.enableFlatpak {
            name = "OBS Studio [${username}]";
            comment = "Flatpak - Free and Open Source Streaming/Recording Software";
            exec = "flatpak run --branch=stable --arch=x86_64 --command=obs com.obsproject.Studio --disable-shutdown-check";
            terminal = false;
            icon = "com.obsproject.Studio";
            type = "Application";
            startupNotify = true;
            categories = [
              "AudioVideo"
              "Recorder"
            ];
          };
          "obs" = lib.mkIf cfg.enableNative {
            name = "OBS Studio [${username}]";
            comment = "Free and Open Source Streaming/Recording Software";
            exec = "GDK_BACKEND=x11 QT_QPA_PLATFORM=xcb obs --disable-shutdown-check";
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
