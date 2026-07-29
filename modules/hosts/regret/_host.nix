{ self, ... }:
{
  configurations.nixos.regret.module =
    { config, ... }:
    {
      imports =
        with self.modules.nixos;
        [
          self.diskoConfigurations.regret

          base-profile
          pi-profile
        ]
        ++ (with inputs.nixos-raspberrypi.nixosModules; [
          inputs.nixos-raspberrypi.lib.inject-overlays
          trusted-nix-caches
          raspberry-pi-4.base
        ]);

      home-manager.users.${config.my.user} = {
        imports = with self.modules.homeManager; [
          base-profile
          pi-profile
        ];
      };

      services.renovate = {
        enable = true;

        credentials = {
          GITHUB_TOKEN = config.sops.secrets."renovate/github_token".path;
          RENOVATE_TOKEN = config.sops.secrets."renovate/renovate_key".path;
        };

        schedule = "*-*-* 00/2:00:00";

        settings = {
          autodiscover = false;
          endpoint = "https://codeberg.org";
          gitAuthor = "Renovate Bot <renovate-bot@echosector.org>";
          onboardingConfigFileName = "renovate.json";
          optimizeForDisabled = true;
          persistRepoData = true;
          platform = "forgejo";
        };
      };
    };
}
