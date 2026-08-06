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
            steamKill = lib.getExe (
              pkgs.writeShellApplication {
                name = "steam-kill";

                text = ''
                  if pgrep -x steam >/dev/null; then
                      steam -shutdown &>/dev/null
                      for _ in {1..30}; do
                          ! pgrep -x steam >/dev/null && break
                          sleep 1
                      done
                  fi
                '';
              }
            );
          in
          {
            application = [
              {
                boxart =
                  let
                    icon = pkgs.fetchurl {
                      hash = "sha256-YZmRA0mMU6Ez6PxskyNasCspGRMeduh+L7JzZ5NQE6I=";
                      url = "https://cdn2.steamgriddb.com/grid/39c2966989c4f0091a99eef7f1d09c09.png";
                    };
                  in
                  icon;

                command = [
                  "${lib.getExe pkgs.steam}"
                  "steam://open/bigpicture"
                ];

                pre_command = [
                  [ steamKill ]
                ];

                title = "Steam";
              }
              {
                boxart =
                  let
                    icon = pkgs.fetchurl {
                      hash = "sha256-DRHwibH9TqqqSl/LZd19zfWE0qe1RTjb8uSbPMtAbTQ=";
                      url = "https://cdn2.steamgriddb.com/grid/2b1c6cedeaf9571589e3dc9d51ba20e5.png";
                    };
                  in
                  icon;

                command = [ "${lib.getExe pkgs.heroic}" ];
                title = "Heroic Games Launcher";
              }
            ];

            application_scanner = [
              {
                boxart =
                  let
                    icon = pkgs.fetchurl {
                      hash = "sha256-YZmRA0mMU6Ez6PxskyNasCspGRMeduh+L7JzZ5NQE6I=";
                      url = "https://cdn2.steamgriddb.com/grid/39c2966989c4f0091a99eef7f1d09c09.png";
                    };
                  in
                  icon;

                command = [
                  "${lib.getExe pkgs.steam}"
                  "-bigpicture"
                  "steam://rungameid/{game_id}"
                ];

                library = "$HOME/.local/share/Steam";

                pre_command = [
                  [ steamKill ]
                ];

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
