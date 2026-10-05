{ inputs, ... }:
{
  flake.modules = {
    homeManager.profile-gaming =
      { lib, pkgs, ... }:
      let
        steamCompatTools = with pkgs; [
          proton-cachyos
          proton-ge
          local.proton-wineland
        ];
      in
      {
        home.packages = with pkgs; [ protonplus ];
        programs.lutris.protonPackages = with pkgs; [ local.proton-wineland ];
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
                      echo "checking for updates: ${name}"
                      update_output="$(protonplus update steam-system ${lib.escapeShellArg slug} 2>&1)" || true
                      echo "$update_output"
                      if grep -qF "Successfully updated" <<< "$update_output"; then
                        notify-send --app-name=ProtonPlus --icon=com.vysp3r.ProtonPlus 'ProtonPlus' 'Updated ${name}'
                      elif grep -qF "Failed to update" <<< "$update_output"; then
                        notify-send --app-name=ProtonPlus --icon=com.vysp3r.ProtonPlus --urgency=critical 'ProtonPlus' 'Failed to update ${name}'
                      fi
                    else
                      echo "installing missing runner: ${name} (${slug})"
                      if protonplus install steam-system ${lib.escapeShellArg slug} latest; then
                        notify-send --app-name=ProtonPlus --icon=com.vysp3r.ProtonPlus 'ProtonPlus' 'Installed ${name}'
                      else
                        notify-send --app-name=ProtonPlus --icon=com.vysp3r.ProtonPlus --urgency=critical 'ProtonPlus' 'Failed to install ${name}'
                      fi
                    fi
                  '') runners
                )}
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
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:Daaboulex/proton-cachyos-nix";
    };
    proton-ge-nix = {
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:Daaboulex/proton-ge-nix";
    };
  };
}
