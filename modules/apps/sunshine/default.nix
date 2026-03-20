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
        secondaryDisplay = "DP-3";
        sunshineDisplay = "HDMI-A-1";
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
                        kscreen-doctor output.${sunshineDisplay}.enable
                        kscreen-doctor output.${sunshineDisplay}.hdr.enable
                        kscreen-doctor output.${sunshineDisplay}.wcg.enable
                        kscreen-doctor output.${sunshineDisplay}.mode.2560x1440@120

                        kscreen-doctor output.${primaryDisplay}.disable
                        kscreen-doctor output.${secondaryDisplay}.disable
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
                        kscreen-doctor output.${primaryDisplay}.enable
                        kscreen-doctor output.${secondaryDisplay}.enable                    
                        kscreen-doctor output.${sunshineDisplay}.disable
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
              detached = [
                "${lib.getExe' pkgs.util-linux "setsid"} ${lib.getExe pkgs.steam} steam://open/bigpicture"
              ];
              prep-cmd = {
                do = "";
                undo = [
                  "${lib.getExe' pkgs.util-linux "setsid"} ${lib.getExe pkgs.steam} steam://close/bigpicture"
                ];
              };
              image-path = "steam.png";
            }
          ];
        };
        settings = {
          output_name = 0; # Fake display
        };
      };
    home-manager.users.${username} = {
      home.packages = with pkgs; [ moondeck-buddy ];
      xdg.autostart.entries = with pkgs; [ "${moondeck-buddy}/share/applications/MoonDeckBuddy.desktop" ];
    };
  };
}
