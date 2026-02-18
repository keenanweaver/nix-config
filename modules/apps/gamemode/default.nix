{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.gamemode;
in
{
  options.gamemode = {
    enable = lib.mkEnableOption "Enable gamemode in NixOS & home-manager";
  };

  config = lib.mkIf cfg.enable {
    programs.gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 10;
        };
        cpu = {
          amd_x3d_mode_default = "frequency";
          amd_x3d_mode_desired = "cache";
          park_cores = "no";
          pin_cores = "1-7,16-23"; # Skip core 0, testing https://kish1n.io/posts/is-core-0-sabotaging-your-performance/
        };
        custom =
          let
            icon = pkgs.fetchurl {
              url = "https://avatars.githubusercontent.com/u/9704713?s=200&v=4";
              hash = "sha256-P6Q/d+VGiMfkAKIygIDCr4Idb6dCxeW+fBQK35ZELPU=";
            };
          in
          {
            start = lib.getExe (
              pkgs.writeShellApplication {
                name = "gamemode-start";
                runtimeInputs = with pkgs; [
                  kdePackages.libkscreen
                  kdePackages.qttools
                  libnotify
                ];
                text = ''
                  notify-send -t 3000 -u low "GameMode" "GameMode started<br>Disabling Night Light" -i ${icon} -a "GameMode"

                  if [ "$(qdbus org.kde.KWin /org/kde/KWin/NightLight org.kde.KWin.NightLight.running)" = "true" ]; then
                    qdbus org.kde.kglobalaccel /component/kwin invokeShortcut "Toggle Night Color"
                  fi
                '';
              }
            );
            end = lib.getExe (
              pkgs.writeShellApplication {
                name = "gamemode-end";
                runtimeInputs = with pkgs; [
                  kdePackages.libkscreen
                  kdePackages.qttools
                  libnotify
                ];
                text = ''
                  notify-send -t 3000 -u low "GameMode" "GameMode stopped<br>Enabling Night Light" -i ${icon} -a "GameMode"

                  if [ "$(qdbus org.kde.KWin /org/kde/KWin/NightLight org.kde.KWin.NightLight.running)" = "false" ]; then
                    qdbus org.kde.kglobalaccel /component/kwin invokeShortcut "Toggle Night Color"
                  fi
                '';
              }
            );
          };
      };
    };
    users.users.${username}.extraGroups = [ "gamemode" ];
    home-manager.users.${username} = { };
  };
}
