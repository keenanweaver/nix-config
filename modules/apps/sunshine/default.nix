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
        capSysAdmin = true;
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
              image-path = "steam.png";
              detached = [ "${lib.getExe pkgs.steam} steam://open/bigpicture" ];
              auto-detach = "true";
              wait-all = "true";
              exit-timeout = "5";
            }
          ];
        };
        settings = {
          output_name = 1;
        };
      };
    home-manager.users.${username} = {
      home.packages = with pkgs; [ moondeck-buddy ];
      xdg.autostart.entries = with pkgs; [ "${moondeck-buddy}/share/applications/MoonDeckBuddy.desktop" ];
    };
  };
}
