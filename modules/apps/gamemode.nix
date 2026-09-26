{
  flake.modules.nixos.profile-gaming =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      nixpkgs.overlays = [
        (_final: prev: {
          gamemode = prev.gamemode.overrideAttrs (_oldAttrs: {
            version = "1.8.2-unstable-2026-06-15";
            src = prev.fetchFromGitHub {
              hash = "sha256-k5pq83KceoPS/bGVur6jhvKNXGJr1KBD0v6YNGB7RMY=";
              owner = "FeralInteractive";
              repo = "gamemode";
              rev = "a74b8106a2236d1f2696aa44c93bc4c8ef13b42e";
            };
          });
        })
      ];
      programs.gamemode = {
        enable = true;
        settings = {
          cpu.park_cores = "no";
          custom =
            let
              icon = pkgs.fetchurl {
                hash = "sha256-P6Q/d+VGiMfkAKIygIDCr4Idb6dCxeW+fBQK35ZELPU=";
                url = "https://avatars.githubusercontent.com/u/9704713?s=200&v=4";
              };
              plasma = config.services.desktopManager.plasma6.enable;
            in
            {
              end = lib.getExe (
                pkgs.writeShellApplication {
                  name = "gamemode-end";
                  runtimeInputs =
                    with pkgs;
                    [
                      libnotify
                      scx-loader
                    ]
                    ++ lib.optionals plasma [
                      kdePackages.libkscreen
                      kdePackages.qttools
                    ];
                  text = ''
                    scxctl stop

                    notify-send -t 3000 -u low "GameMode" \
                      "GameMode stopped${lib.optionalString plasma "<br>Enabling Night Light"}" \
                      -i ${icon} -a "GameMode"
                  ''
                  + lib.optionalString plasma ''

                    if [ "$(qdbus org.kde.KWin /org/kde/KWin/NightLight org.kde.KWin.NightLight.running)" = "false" ]; then
                      qdbus org.kde.kglobalaccel /component/kwin invokeShortcut "Toggle Night Color"
                    fi
                  '';
                }
              );
              start = lib.getExe (
                pkgs.writeShellApplication {
                  name = "gamemode-start";
                  runtimeInputs =
                    with pkgs;
                    [
                      libnotify
                      scx-loader
                    ]
                    ++ lib.optionals plasma [
                      kdePackages.libkscreen
                      kdePackages.qttools
                    ];
                  text = ''
                    if [[ "$(scxctl get 2>/dev/null)" != *"Cake in LowLatency"* ]]; then
                      scxctl start --sched scx_cake --mode gaming
                    fi

                    notify-send -t 3000 -u low "GameMode" \
                      "GameMode started${lib.optionalString plasma "<br>Disabling Night Light"}<br>Enabling scx_cake" \
                      -i ${icon} -a "GameMode"
                  ''
                  + lib.optionalString plasma ''

                    if [ "$(qdbus org.kde.KWin /org/kde/KWin/NightLight org.kde.KWin.NightLight.running)" = "true" ]; then
                      qdbus org.kde.kglobalaccel /component/kwin invokeShortcut "Toggle Night Color"
                    fi
                  '';
                }
              );
            };
          general.renice = 10;
        };
      };
      users.users.${config.my.user}.extraGroups = [ "gamemode" ];
    };
}
