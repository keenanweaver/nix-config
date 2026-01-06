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
        custom = {
          start = lib.getExe (
            pkgs.writeShellApplication {
              name = "gamemode-start";
              runtimeInputs = with pkgs; [
                kdePackages.libkscreen
                kdePackages.qttools
                libnotify
              ];
              text = ''
                notify-send -t 3000 -u low "GameMode" "GameMode started<br>Disabling Night Light" -i input-gamepad -a "GameMode"

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
                notify-send -t 3000 -u low "GameMode" "GameMode stopped<br>Enabling Night Light" -i input-gamepad -a "GameMode"

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
