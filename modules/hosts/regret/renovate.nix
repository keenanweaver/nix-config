{
  configurations.nixos.regret.module =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      codebergTokenFile = config.sops.secrets."renovate/codeberg_bot_pat".path;
      ntfyTokenFile = config.sops.secrets."ntfy/ntfybot_token".path;
      renovateNotifyMerged = pkgs.writeShellApplication {
        excludeShellChecks = [ "SC2329" ];
        name = "renovate-notify-merged";
        runtimeInputs = [
          pkgs.curl
          pkgs.jq
        ];
        text = ''
          # shellcheck disable=SC2154 # STATE_DIRECTORY is set by systemd's StateDirectory=
          state_file="$STATE_DIRECTORY/notify-merged-last-pr"

          ntfy_notify() {
            local title="$1" message="$2" tags="$3" priority="''${4:-default}"
            curl -fsS \
              --header "Authorization: Bearer $(cat ${lib.escapeShellArg ntfyTokenFile})" \
              --header "Title: $title" \
              --header "Tags: $tags" \
              --header "Priority: $priority" \
              --data "$message" \
              "http://10.20.20.31/renovate" >/dev/null || true
          }

          merged_prs=$(curl -fsS \
            --header "Authorization: token $(cat ${lib.escapeShellArg codebergTokenFile})" \
            "https://codeberg.org/api/v1/repos/Keenan/nix-config/pulls?state=closed&sort=recentupdate&limit=20" \
            | jq -c '[.[] | select(.merged == true)]')

          if [ ! -f "$state_file" ]; then
            current_max=$(printf '%s' "$merged_prs" | jq -r 'map(.number) | max // 0')
            echo "$current_max" > "$state_file"
            echo "no prior state; recording current max merged PR (#$current_max) without notifying"
            exit 0
          fi
          last_seen=$(cat "$state_file")

          mapfile -t new_numbers < <(
            printf '%s' "$merged_prs" | jq -r --argjson last "$last_seen" \
              '.[] | select(.number > $last) | .number'
          )

          if [ "''${#new_numbers[@]}" -eq 0 ]; then
            echo "no new merged PRs (last seen #$last_seen)"
            exit 0
          fi

          for number in "''${new_numbers[@]}"; do
            title=$(printf '%s' "$merged_prs" | jq -r --argjson n "$number" '.[] | select(.number == $n) | .title')
            echo "notifying: merged #$number: $title"
            ntfy_notify "Renovate" "Merged #$number: $title" "white_check_mark"
          done

          max_number=$(printf '%s\n' "''${new_numbers[@]}" | sort -n | tail -1)
          echo "$max_number" > "$state_file"
        '';
      };
    in
    {
      nix.settings.allowed-users = lib.mkDefault [ "renovate" ];
      services.renovate = {
        enable = true;
        credentials = {
          GITHUB_COM_TOKEN = config.sops.secrets."renovate/github_access_token".path;
          RENOVATE_GIT_PRIVATE_KEY = config.sops.secrets."renovate/git_signing".path;
          RENOVATE_HOST_RULES = config.sops.secrets."renovate/nonfree_host_rules".path;
          RENOVATE_TOKEN = config.sops.secrets."renovate/codeberg_bot_pat".path;
        };
        runtimePackages = with pkgs; [
          nix
          openssh
        ];
        schedule = null;
        settings = {
          autodiscover = false;
          automerge = true;
          automergeType = "branch";
          configMigration = true;
          endpoint = "https://codeberg.org";
          extends = [ "config:recommended" ];
          gitAuthor = "Keenan-Renovate <keenan-renovate@noreply.codeberg.org>";
          ignoreTests = true;
          lockFileMaintenance = {
            enabled = true;
            schedule = [ "at any time" ];
          };
          nix.enabled = true;
          onboardingConfigFileName = "renovate.json";
          optimizeForDisabled = true;
          osvVulnerabilityAlerts = true;
          packageRules = [
            {
              groupName = "flake inputs";
              matchManagers = [ "nix" ];
            }
          ];
          persistRepoData = true;
          platform = "forgejo";
          prConcurrentLimit = 0;
          prHourlyLimit = 0;
          repositories = [ "Keenan/nix-config" ];
        };
        validateSettings = true;
      };
      sops.secrets = {
        "ntfy/ntfybot_token" = { };
        "renovate/codeberg_bot_pat" = { };
        "renovate/git_signing" = { };
        "renovate/github_access_token" = { };
        "renovate/nonfree_host_rules" = { };
      };
      systemd.services = {
        renovate.serviceConfig.ExecStopPost = [ (lib.getExe renovateNotifyMerged) ];
        renovate-watch-nixos-unstable = {
          description = "Trigger renovate when nixpkgs nixos-unstable advances";
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          serviceConfig = {
            ExecStart = lib.getExe (
              pkgs.writeShellApplication {
                name = "renovate-watch-nixos-unstable";
                runtimeInputs = [
                  config.systemd.package
                  pkgs.git
                ];
                text = ''
                  # shellcheck disable=SC2154 # STATE_DIRECTORY is set by systemd's StateDirectory=
                  state_file="$STATE_DIRECTORY/last-sha"
                  current_sha=$(git ls-remote https://github.com/NixOS/nixpkgs.git refs/heads/nixos-unstable | cut -f1)
                  if [ -z "$current_sha" ]; then
                    echo "failed to resolve nixos-unstable HEAD" >&2
                    exit 1
                  fi
                  if [ ! -f "$state_file" ]; then
                    echo "$current_sha" > "$state_file"
                    echo "no prior state; recording nixos-unstable HEAD ($current_sha) without starting renovate"
                    exit 0
                  fi
                  last_sha=$(cat "$state_file")
                  if [ "$current_sha" != "$last_sha" ]; then
                    echo "$current_sha" > "$state_file"
                    echo "nixos-unstable moved: $last_sha -> $current_sha; starting renovate"
                    systemctl start renovate.service
                  else
                    echo "nixos-unstable unchanged ($current_sha)"
                  fi
                '';
              }
            );
            StateDirectory = "renovate-watch-nixos-unstable";
            Type = "oneshot";
          };
          startAt = "hourly";
        };
      };
    };
}
