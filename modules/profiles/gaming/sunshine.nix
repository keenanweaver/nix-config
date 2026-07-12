{
  flake.modules = {
    homeManager.sunshine = { pkgs, ... }: {
      home.packages = [ pkgs.local.moondeck-buddy ];
      xdg.autostart.entries = [ "${pkgs.local.moondeck-buddy}/share/applications/MoonDeckBuddy.desktop" ];
    };
    nixos.gaming-profile = {
      networking.firewall = {
        allowedTCPPorts = [
          # MoonDeck Buddy
          59999
          # Moonlight
          47984
          47989
          48010
        ];
        allowedUDPPorts = [
          # Moonlight
          5353
          47998
          47999
          48000
          48002
          48010
        ];
      };
      programs.moonlight-qt = {
        enable = true;
        capSysNice = true;
      };
    };
    nixos.sunshine =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        services.sunshine =
          let
            inherit (config.host)
              primaryMonitor
              ;
          in
          {
            enable = true;
            applications = {
              apps = [
                {
                  auto-detach = "true";
                  exclude-global-prep-cmd = "false";
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
                            kscreen-doctor output.${primaryMonitor}.hdr.enable
                            kscreen-doctor output.${primaryMonitor}.wcg.enable
                            kscreen-doctor output.${primaryMonitor}.mode.2560x1440@120
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
                            kscreen-doctor output.${primaryMonitor}.hdr.disable
                            kscreen-doctor output.${primaryMonitor}.wcg.disable
                            kscreen-doctor output.${primaryMonitor}.wcg.enable
                            kscreen-doctor output.${primaryMonitor}.mode.2560x1440@360
                          '';
                        });
                    }
                  ];
                }
                {
                  cmd = lib.getExe pkgs.local.moondeck-buddy;
                  elevated = "false";
                  exclude-global-prep-cmd = "false";
                  name = "MoonDeckStream";
                }
                {
                  auto-detach = "true";
                  detached = [ "${lib.getExe' pkgs.xdg-utils "xdg-open"} steam://open/bigpicture" ];
                  image-path = "steam.png";
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
                            kscreen-doctor output.${primaryMonitor}.hdr.enable
                            kscreen-doctor output.${primaryMonitor}.wcg.enable
                            kscreen-doctor output.${primaryMonitor}.mode.2560x1440@120
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
                            kscreen-doctor output.${primaryMonitor}.hdr.disable
                            kscreen-doctor output.${primaryMonitor}.wcg.disable
                            kscreen-doctor output.${primaryMonitor}.wcg.enable
                            kscreen-doctor output.${primaryMonitor}.mode.2560x1440@360
                            setsid steam steam://close/bigpicture
                          '';
                        });
                    }
                  ];
                }
              ];
              env = {
                PATH = "$(PATH):/run/current-system/sw/bin:/etc/profiles/per-user/${config.my.user}/bin:$(HOME)/.local/bin";
              };
            };
            autoStart = true;
            capSysAdmin = true; # Set to false to fix non-desktop https://github.com/NixOS/nixpkgs/issues/463989
            openFirewall = true;
            settings = {
              csrf_allowed_origins = builtins.concatStringsSep "," [
                "https://10.20.20.5:47990"
                "https://nixos-desktop:47990"
                "https://100.99.122.5:47990"
                "https://nixos-desktop.tailffbf85.ts.net:47990"
              ];
              output_name = 1;
              system_tray = false;
            };
          };
      };
  };
}
