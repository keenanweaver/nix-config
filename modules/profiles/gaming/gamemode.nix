{
  configurations.nixos.nixos-desktop.module = {
    programs.gamemode = {
      settings = {
        cpu = {
          pin_cores = "1-7,16-23"; # Skip core 0, testing https://kish1n.io/posts/is-core-0-sabotaging-your-performance/
        };
      };
    };
  };
  flake.modules.nixos.gaming-profile =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      nixpkgs.overlays = [
        (_final: prev: {
          gamemode = prev.gamemode.overrideAttrs {
            src = prev.fetchFromGitHub {
              hash = "sha256-k5pq83KceoPS/bGVur6jhvKNXGJr1KBD0v6YNGB7RMY=";
              owner = "FeralInteractive";
              repo = "gamemode";
              rev = "a74b8106a2236d1f2696aa44c93bc4c8ef13b42e";
            };
            version = "1.8.2-unstable-06-15-2026";
          };
        })
      ];

      programs.gamemode = {
        enable = true;
        settings = {
          cpu = {
            # https://github.com/aamaanaa/X3D-Cache-Core-Parking-on-Fedora
            park_cores = "no";
          };
          custom =
            let
              icon = pkgs.fetchurl {
                hash = "sha256-P6Q/d+VGiMfkAKIygIDCr4Idb6dCxeW+fBQK35ZELPU=";
                url = "https://avatars.githubusercontent.com/u/9704713?s=200&v=4";
              };
            in
            {
              end = lib.getExe (
                pkgs.writeShellApplication {
                  name = "gamemode-end";
                  runtimeInputs = with pkgs; [
                    kdePackages.libkscreen
                    kdePackages.qttools
                    libnotify
                    scx-loader
                  ];
                  text = ''
                    scxctl restore

                    notify-send -t 3000 -u low "GameMode" \
                      "GameMode stopped<br>Enabling Night Light<br>Enabling scx_pandemonium" \
                      -i ${icon} -a "GameMode"

                    if [ "$(qdbus org.kde.KWin /org/kde/KWin/NightLight org.kde.KWin.NightLight.running)" = "false" ]; then
                      qdbus org.kde.kglobalaccel /component/kwin invokeShortcut "Toggle Night Color"
                    fi
                  '';
                }
              );
              start = lib.getExe (
                pkgs.writeShellApplication {
                  name = "gamemode-start";
                  runtimeInputs = with pkgs; [
                    kdePackages.libkscreen
                    kdePackages.qttools
                    libnotify
                    scx-loader
                  ];
                  text = ''
                    if [[ "$(scxctl get 2>/dev/null)" != *"Cake in LowLatency"* ]]; then
                      scxctl switch --sched scx_cake --mode gaming
                    fi

                    notify-send -t 3000 -u low "GameMode" \
                      "GameMode started<br>Disabling Night Light<br>Enabling scx_cake" \
                      -i ${icon} -a "GameMode"

                    if [ "$(qdbus org.kde.KWin /org/kde/KWin/NightLight org.kde.KWin.NightLight.running)" = "true" ]; then
                      qdbus org.kde.kglobalaccel /component/kwin invokeShortcut "Toggle Night Color"
                    fi
                  '';
                }
              );
            };
          general = {
            renice = 10;
          };
        };
      };

      users.users.${config.my.user}.extraGroups = [ "gamemode" ];
    };
}
