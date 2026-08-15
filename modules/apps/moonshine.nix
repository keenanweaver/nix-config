{
  flake.modules.nixos.moonshine =
    {
      inputs,
      lib,
      config,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.moonshine.nixosModules.default ];

      networking.firewall = {
        allowedTCPPorts = [
          # Moonlight
          47984
          47989
          48010
          # MoonDeck Buddy
          59999
        ];

        allowedUDPPorts = [
          47998
          47999
          48000
          48002
          48010
          # Moonlight
          5353
        ];
      };

      services.moonshine = {
        enable = true;
        openFirewall = true;

        settings =
          let
            fetchIcon =
              gridId: hash:
              pkgs.fetchurl {
                inherit hash;
                url = "https://cdn2.steamgriddb.com/grid/${gridId}.png";
              };
            heroicExe = lib.getExe pkgs.heroic;
            heroicIcon = fetchIcon "2b1c6cedeaf9571589e3dc9d51ba20e5" "sha256-DRHwibH9TqqqSl/LZd19zfWE0qe1RTjb8uSbPMtAbTQ=";
            heroicKill = mkKill { name = "heroic"; };
            lutrisExe = lib.getExe pkgs.lutris;
            lutrisIcon = fetchIcon "3b0d861c2cf5ed4d7b139ee277c8a04a" "sha256-ssrFE/Q1vAB0nWqnX2yOXy3NW/ckfVUGFt3kS6jOZuw=";
            lutrisKill = mkKill { name = "lutris"; };
            mkKill =
              {
                name,
                bin ? name,
                shutdownCmd ? null,
              }:
              lib.getExe (
                pkgs.writeShellApplication {
                  name = "${name}-kill";

                  text = ''
                    if pgrep -x ${bin} >/dev/null; then
                        ${lib.optionalString (shutdownCmd != null) "${shutdownCmd}\n    "}for _ in {1..30}; do
                            ! pgrep -x ${bin} >/dev/null && break
                            sleep 1
                        done
                    fi
                  '';
                }
              );
            steamExe = lib.getExe pkgs.steam;
            steamIcon = fetchIcon "39c2966989c4f0091a99eef7f1d09c09" "sha256-YZmRA0mMU6Ez6PxskyNasCspGRMeduh+L7JzZ5NQE6I=";
            steamKill = mkKill {
              name = "steam";
              shutdownCmd = "${steamExe} -shutdown &>/dev/null";
            };
          in
          {
            application = [
              {
                boxart = steamIcon;

                command = [
                  steamExe
                  "steam://open/bigpicture"
                ];

                pre_command = [ [ steamKill ] ];
                title = "Steam";
              }
              {
                boxart = heroicIcon;
                command = [ heroicExe ];
                post_command = [ [ heroicKill ] ];
                title = "Heroic Games Launcher";
              }
            ];

            application_scanner = [
              {
                boxart = lutrisIcon;

                command = [
                  lutrisExe
                  "lutris:rungame/{slug}"
                ];

                post_command = [ [ lutrisKill ] ];
                type = "lutris";
              }
              {
                boxart = heroicIcon;

                command = [
                  heroicExe
                  "--no-gui"
                  "heroic://launch?appName={app_name}&runner={runner}"
                ];

                type = "heroic";
              }
              {
                boxart = steamIcon;

                command = [
                  steamExe
                  "-bigpicture"
                  "steam://rungameid/{game_id}"
                ];

                library = "$HOME/.local/share/Steam";
                pre_command = [ [ steamKill ] ];
                type = "steam";
              }
            ];
          };

        uid = 1000;
        user = config.my.user;
      };

      users.users.${config.my.user}.extraGroups = [ "moonshine" ];
    };

  flake-file.inputs.moonshine = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:hgaiser/moonshine";
  };
}
