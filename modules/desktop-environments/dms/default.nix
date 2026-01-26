{
  lib,
  pkgs,
  inputs,
  config,
  username,
  ...
}:
let
  cfg = config.dms;
  enablePlugins =
    plugins:
    lib.genAttrs plugins (_: {
      enable = true;
    });
in
{
  options.dms = {
    enable = lib.mkEnableOption "Enable dms in NixOS";
  };

  config = lib.mkIf cfg.enable {
    programs.dms-shell = {
      enable = true;
      package = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;
      quickshell.package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.quickshell;

      # Get IDs from: https://danklinux.com/plugins
      plugins = enablePlugins [
        "amdGpuMonitor"
        "appShortcut"
        "calculator"
        "commandRunner"
        "dankActions"
        "dankBatteryAlerts"
        "dankBitwarden"
        "dankClight"
        "dankDesktopWeather"
        "dankHooks"
        "dankKDEConnect"
        "dankLauncherKeys"
        "desktopCommand"
        "displayManager"
        "displayMirror"
        "dockerManager"
        "easyEffects"
        "emojiLauncher"
        "linuxWallpaperEngine"
        "mediaPlayer"
        "niriWindows"
        "nixMonitor"
        "powerOptions"
        "powerUsagePlugin"
        "sessionPower"
        "tailscale"
        "vscodeLauncher"
        "webSearch"
      ];

      systemd = {
        enable = true;
        restartIfChanged = true;
      };

    };

    services.gnome.gcr-ssh-agent.enable = lib.mkForce false;

    home-manager.users.${username} = { };
  };
}
