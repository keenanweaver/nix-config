{ inputs, ... }:
{
  flake.modules = {
    homeManager.profile-gaming =
      {
        lib,
        config,
        pkgs,
        osConfig,
        ...
      }:
      let
        steamCompatTools = with pkgs; [
          proton-cachyos
          proton-ge
          local.proton-wineland
        ];
      in
      {
        home.packages = with pkgs; [ protonplus ];
        systemd.user =
          let
            install-runners = pkgs.writeShellApplication {
              name = "protonplus-install-runners";
              runtimeInputs = with pkgs; [
                coreutils
                dconf
                libnotify
                protonplus
              ];
              text = ''
                token_file=${
                  lib.escapeShellArg osConfig.sops.secrets."users/${config.home.username}/github_pat".path
                }
                if [ -r "$token_file" ]; then
                  trap 'dconf reset /com/vysp3r/ProtonPlus/State/github-api-key' EXIT
                  printf "[/]\ngithub-api-key='%s'\n" "$(tr -d '[:space:]' <"$token_file")" |
                    dconf load /com/vysp3r/ProtonPlus/State/
                fi

                notify() {
                  notify-send --app-name=ProtonPlus --icon=com.vysp3r.ProtonPlus --urgency="$1" ProtonPlus "$2"
                }

                installed="$(protonplus list steam-system 2>/dev/null || true)"

                sync_runner() {
                  local name=$1 slug=$2 output
                  if [[ $installed == *"$name"* ]]; then
                    echo "checking for updates: $name"
                    output="$(protonplus update steam-system "$slug" 2>&1)" || true
                    echo "$output"
                    case $output in
                      *"Successfully updated"*) notify normal "Updated $name" ;;
                      *"Failed to update"*) notify critical "Failed to update $name" ;;
                    esac
                  else
                    echo "installing missing runner: $name ($slug)"
                    if protonplus install steam-system "$slug" latest; then
                      notify normal "Installed $name"
                    else
                      notify critical "Failed to install $name"
                    fi
                  fi
                }

                ${lib.concatMapAttrsStringSep "\n" (
                  name: slug: "sync_runner ${lib.escapeShellArg name} ${lib.escapeShellArg slug}"
                ) runners}
              '';
            };
            runners = {
              "Luxtorpeda Latest" = "luxtorpeda";
              "Proton-CachyOS Latest" = "proton-cachyos";
              "Proton-GE Latest" = "proton-ge";
              "Proton-Wineland Latest" = "proton-wineland";
            };
          in
          {
            services.protonplus-update = {
              Install.WantedBy = [ "graphical-session.target" ];
              Service = {
                ExecStart = lib.getExe install-runners;
                ExecStartPre = "${lib.getExe' pkgs.networkmanager "nm-online"} -q -t 60";
                Type = "oneshot";
              };
              Unit = {
                After = [ "graphical-session.target" ];
                Description = "Install runners for ProtonPlus";
              };
            };
            timers.protonplus-update = {
              Install.WantedBy = [ "graphical-session.target" ];
              Timer.OnCalendar = "hourly";
              Unit = {
                Description = "Check for Proton runner updates hourly";
                PartOf = [ "graphical-session.target" ];
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
    nixos.profile-gaming =
      { lib, ... }:
      {
        nixpkgs.overlays = lib.mkAfter [
          inputs.proton-cachyos-nix.overlays.default
          inputs.proton-ge-nix.overlays.default
        ];
      };
  };
  flake-file.inputs = {
    proton-cachyos-nix = {
      inputs = {
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks-nix";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:Daaboulex/proton-cachyos-nix";
    };
    proton-ge-nix = {
      inputs = {
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks-nix";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:Daaboulex/proton-ge-nix";
    };
  };
}
