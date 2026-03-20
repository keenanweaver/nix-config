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
        prepDisplay = pkgs.writeShellApplication {
          name = "sunshine-desktop-do";
          runtimeInputs = with pkgs; [
            kdePackages.libkscreen
          ];
          text = ''
            kscreen-doctor output.${sunshineDisplay}.enable   \
              output.${sunshineDisplay}.hdr.enable            \
              output.${sunshineDisplay}.wcg.enable            \
              output.${sunshineDisplay}.mode.2560x1440@120    \
              output.${sunshineDisplay}.vrrpolicy.automatic   \
              output.${primaryDisplay}.disable                \
              output.${secondaryDisplay}.disable
          '';
        };
        restoreDisplay = pkgs.writeShellApplication {
          name = "sunshine-desktop-undo";
          runtimeInputs = with pkgs; [
            kdePackages.libkscreen
          ];
          text = ''
            kscreen-doctor output.${primaryDisplay}.enable   \
              output.${secondaryDisplay}.enable              \     
              output.${sunshineDisplay}.disable
          '';
        };
        restoreDisplaySteam = pkgs.writeShellApplication {
          name = "sunshine-desktop-undo-steam";
          runtimeInputs = with pkgs; [
            kdePackages.libkscreen
            steam
            util-linux
          ];
          text = ''
            sudo -u ${username} setsid steam steam://close/bigpicture
          ''
          + prepDisplay.text;
        };
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
                  do = lib.getExe prepDisplay;
                  undo = lib.getExe restoreDisplay;
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
              detached = [
                "${lib.getExe' pkgs.util-linux "setsid"} ${lib.getExe pkgs.steam} steam://open/bigpicture"
              ];
              prep-cmd = [
                {
                  do = lib.getExe prepDisplay;
                  undo = lib.getExe restoreDisplaySteam;
                }
              ];
              auto-detach = "true";
              wait-all = "true";
              exit-timeout = "5";
            }
          ];
        };
        settings = {
          capture = "kms";
          output_name = 0; # Fake display
        };
      };
    home-manager.users.${username} = {
      home.packages = with pkgs; [ moondeck-buddy ];
      xdg.autostart.entries = with pkgs; [ "${moondeck-buddy}/share/applications/MoonDeckBuddy.desktop" ];
    };
  };
}
