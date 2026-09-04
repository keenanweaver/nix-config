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
        schedule = "*-*-* 00/5:00:00";
        settings = {
          autodiscover = false;
          endpoint = "https://codeberg.org";
          extends = [ "config:recommended" ];
          gitAuthor = "Keenan-Renovate <keenan-renovate@noreply.codeberg.org>";
          lockFileMaintenance = {
            enabled = true;
            extends = [ "schedule:daily" ];
          };
          nix.enabled = true;
          onboardingConfigFileName = "renovate.json";
          optimizeForDisabled = true;
          persistRepoData = true;
          platform = "forgejo";
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
    };
}
