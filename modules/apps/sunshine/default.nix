{
  lib,
  config,
  username,
  pkgs,
  ...
}:
{
  options = {
    sunshine = {
      enable = lib.mkEnableOption "Enable Sunshine in NixOS";
    };
  };
  config = lib.mkIf config.sunshine.enable {
    networking = {
      firewall = {
        allowedUDPPorts = [
          # Moonlight
          5353
          47998
          47999
          48000
          48002
          48010
        ];
        allowedTCPPorts = [
          # MoonDeck Buddy
          59999
          # Moonlight
          47984
          47989
          48010
        ];
      };
    };

    services.sunshine =
      let
        primaryDisplay = "DP-1";
      in
      {
        enable = true;
        autoStart = true;
        capSysAdmin = true; # Set to false to fix non-desktop https://github.com/NixOS/nixpkgs/issues/463989
        openFirewall = true;
        applications = {
          env = {
            PATH = "$(PATH):/run/current-system/sw/bin:/etc/profiles/per-user/${username}/bin:$(HOME)/.local/bin";
          };
          apps = [
            {
              name = "Desktop";
              prep-cmd = [
                {
                  do =
                    with pkgs;
                    lib.getExe (writeShellApplication {
                      name = "sunshine-desktop-do";
                      runtimeInputs = [
                        kdePackages.libkscreen
                      ];
                      text = ''
                        kscreen-doctor output.${primaryDisplay}.hdr.enable
                        kscreen-doctor output.${primaryDisplay}.wcg.enable
                        kscreen-doctor output.${primaryDisplay}.mode.2560x1440@120
                      '';
                    });
                  undo =
                    with pkgs;
                    lib.getExe (writeShellApplication {
                      name = "sunshine-desktop-undo";
                      runtimeInputs = [
                        kdePackages.libkscreen
                      ];
                      text = ''
                        kscreen-doctor output.${primaryDisplay}.hdr.disable
                        kscreen-doctor output.${primaryDisplay}.wcg.disable
                        kscreen-doctor output.${primaryDisplay}.wcg.enable
                        kscreen-doctor output.${primaryDisplay}.mode.2560x1440@360
                      '';
                    });
                }
              ];
              exclude-global-prep-cmd = "false";
              auto-detach = "true";
            }
            {
              name = "MoonDeckStream";
              cmd = lib.getExe pkgs.moondeck-buddy;
              exclude-global-prep-cmd = "false";
              elevated = "false";
            }
            {
              name = "Steam Big Picture";
              prep-cmd = [
                {
                  do =
                    with pkgs;
                    lib.getExe (writeShellApplication {
                      name = "sunshine-steam-do";
                      runtimeInputs = [
                        kdePackages.libkscreen
                      ];
                      text = ''
                        kscreen-doctor output.${primaryDisplay}.hdr.enable
                        kscreen-doctor output.${primaryDisplay}.wcg.enable
                        kscreen-doctor output.${primaryDisplay}.mode.2560x1440@120
                      '';
                    });
                  undo =
                    with pkgs;
                    lib.getExe (writeShellApplication {
                      name = "sunshine-steam-undo";
                      runtimeInputs = [
                        kdePackages.libkscreen
                      ];
                      text = ''
                        kscreen-doctor output.${primaryDisplay}.hdr.disable
                        kscreen-doctor output.${primaryDisplay}.wcg.disable
                        kscreen-doctor output.${primaryDisplay}.wcg.enable
                        kscreen-doctor output.${primaryDisplay}.mode.2560x1440@360
                        setsid steam steam://close/bigpicture
                        sleep 5
                        pkill -TERM steam
                      '';
                    });
                }
              ];
              image-path = "steam.png";
              detached = [ "setsid steam steam://open/bigpicture" ];
              auto-detach = "true";
              wait-all = "true";
              exit-timeout = "5";
            }
          ];
        };
        settings = {
          output_name = 1;
          system_tray = false;
          csrf_allowed_origins = builtins.concatStringsSep "," [
            "https://10.20.20.5:47990"
            "https://nixos-desktop:47990"
            "https://100.99.122.5:47990"
            "https://nixos-desktop.tailffbf85.ts.net:47990"
          ];
        };
      };
    home-manager.users.${username} = {
      home.packages = with pkgs; [ moondeck-buddy ];
      xdg.autostart.entries = with pkgs; [ "${moondeck-buddy}/share/applications/MoonDeckBuddy.desktop" ];
    };
  };
}
