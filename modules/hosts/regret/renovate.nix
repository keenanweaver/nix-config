{
  configurations.nixos.regret.module =
    {
      lib,
      config,
      pkgs,
      ...
    }:
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
          automergeType = "pr";
          configMigration = true;
          endpoint = "https://codeberg.org";
          extends = [ "config:recommended" ];
          gitAuthor = "Keenan-Renovate <keenan-renovate@noreply.codeberg.org>";
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
        "renovate/codeberg_bot_pat" = { };
        "renovate/git_signing" = { };
        "renovate/github_access_token" = { };
        "renovate/nonfree_host_rules" = { };
      };
      systemd.services.renovate-watch-nixos-unstable = {
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
        startAt = "00,06,12,18:00:00";
      };
    };
}
