{ inputs, ... }:
{
  flake.modules = {
    homeManager.gaming-profile =
      { lib, pkgs, ... }:
      let
        steamCompatTools = with pkgs; [
          proton-cachyos
        ];
      in
      {
        programs.lutris.protonPackages = steamCompatTools;

        systemd.user =
          let
            install-runners = pkgs.writeShellApplication {
              name = "protonplus-install-runners";

              runtimeInputs = with pkgs; [
                gnugrep
                libnotify
                protonplus
              ];

              text = ''
                installed="$(protonplus list steam-system 2>/dev/null || true)"
                ${lib.concatStringsSep "\n" (
                  lib.mapAttrsToList (name: slug: ''
                    if grep -qF ${lib.escapeShellArg name} <<< "$installed"; then
                      echo "present: ${name}"
                    else
                      echo "installing missing runner: ${name} (${slug})"
                      protonplus install steam-system ${lib.escapeShellArg slug} latest || true
                      notify-send --app-name=ProtonPlus --icon=com.vysp3r.ProtonPlus 'ProtonPlus' 'Installed ${name}'
                    fi
                  '') runners
                )}
              '';
            };
            runners = {
              "Proton-CachyOS Latest" = "proton-cachyos";
            };
            update-runners = pkgs.writeShellApplication {
              name = "protonplus-update-runners";

              runtimeInputs = with pkgs; [
                gnused
                libnotify
                protonplus
              ];

              text = ''
                output="$(protonplus update all 2>&1 || true)"
                echo "$output"

                updated="$(
                  printf '%s\n' "$output" \
                    | sed -n \
                        -e 's/\x1b\[[0-9;]*[a-zA-Z]//g' \
                        -e 's/.*\r//' \
                        -e 's/^Successfully updated //p'
                )"

                if [[ -n "$updated" ]]; then
                  list="''${updated//$'\n'/, }"
                  notify-send --app-name=ProtonPlus --icon=com.vysp3r.ProtonPlus 'ProtonPlus' "Updated: $list"
                fi
              '';
            };
          in
          {
            services.protonplus-update = {
              Install.WantedBy = [ "graphical-session.target" ];

              Service = {
                ExecStart = "${lib.getExe update-runners}";
                ExecStartPre = "${lib.getExe install-runners}";
                Type = "oneshot";
              };

              Unit = {
                After = [
                  "graphical-session.target"
                  "network-online.target"
                ];

                Description = "Update runners for ProtonPlus";
                Wants = [ "network-online.target" ];
              };
            };
          };

        xdg.dataFile = lib.genAttrs' steamCompatTools (
          tool:
          lib.nameValuePair "Steam/compatibilitytools.d/${lib.getName tool}" {
            source = tool.steamcompattool;
          }
        );
      };

    nixos.gaming-profile =
      { pkgs, ... }:
      let
        steamCompatTools = with pkgs; [
          proton-cachyos
        ];
      in
      {
        nixpkgs.overlays = [
          (_final: prev: {
            proton-cachyos = inputs.nix-gaming-edge.packages.${prev.stdenv.hostPlatform.system}.proton-cachyos;
          })
        ];

        programs.steam.extraCompatPackages = steamCompatTools;
      };
  };
}
