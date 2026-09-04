{ self, ... }:
{
  configurations.nixos.regret.module =
    {
      inputs,
      lib,
      config,
      pkgs,
      ...
    }:
    {
      imports =
        with self.modules.nixos;
        [
          profile-base
          profile-pi
        ]
        ++ (with inputs.nixos-raspberrypi.nixosModules; [
          inputs.nixos-raspberrypi.lib.inject-overlays
          trusted-nix-caches
          raspberry-pi-4.base
          sd-image
        ]);
      boot.kernelPackages =
        lib.mkForce
          inputs.nixos-raspberrypi.packages.${pkgs.stdenv.hostPlatform.system}.linuxPackages_rpi4;
      home-manager.users.${config.my.user}.imports = with self.modules.homeManager; [
        profile-base
        profile-pi
      ];
      networking.hostName = "regret";
      services.renovate = {
        enable = true;
        credentials = {
          GITHUB_TOKEN = config.sops.secrets."renovate/github_access_token".path;
          RENOVATE_GIT_PRIVATE_KEY = config.sops.secrets."renovate/git_signing".path;
          RENOVATE_TOKEN = config.sops.secrets."renovate/codeberg_bot_pat".path;
        };
        runtimePackages = with pkgs; [
          nix
          nix-update
          openssh
        ];
        schedule = "*-*-* 00/5:00:00";
        settings = {
          allowedCommands = [ "^nix-update " ];
          autodiscover = false;
          customManagers = [
            {
              currentValueTemplate = "master";
              customType = "regex";
              datasourceTemplate = "git-refs";
              depNameTemplate = "{{{packageName}}}";
              managerFilePatterns = [ "/^pkgs/lgogdownloader/package\\.nix$/" ];
              matchStrings = [
                "owner = \"(?<depName>[^\"]+)\";\\s*repo = \"(?<packageName>[^\"]+)\";\\s*rev = \"(?<currentDigest>[a-f0-9]{40})\";"
              ];
              packageNameTemplate = "https://github.com/{{{depName}}}/{{{packageName}}}";
            }
            {
              currentValueTemplate = "master";
              customType = "regex";
              datasourceTemplate = "git-refs";
              depNameTemplate = "{{{packageName}}}";
              managerFilePatterns = [ "/^pkgs/nuked-sc55/package\\.nix$/" ];
              matchStrings = [
                "owner = \"(?<depName>[^\"]+)\";\\s*repo = \"(?<packageName>[^\"]+)\";\\s*rev = \"(?<currentDigest>[a-f0-9]{40})\";"
              ];
              packageNameTemplate = "https://github.com/{{{depName}}}/{{{packageName}}}";
            }
            {
              currentValueTemplate = "oxce-plus";
              customType = "regex";
              datasourceTemplate = "git-refs";
              depNameTemplate = "{{{packageName}}}";
              managerFilePatterns = [ "/^pkgs/openxcom-extended/package\\.nix$/" ];
              matchStrings = [
                "owner = \"(?<depName>[^\"]+)\";\\s*repo = \"(?<packageName>[^\"]+)\";\\s*rev = \"(?<currentDigest>[a-f0-9]{40})\";"
              ];
              packageNameTemplate = "https://github.com/{{{depName}}}/{{{packageName}}}";
            }
            {
              currentValueTemplate = "main";
              customType = "regex";
              datasourceTemplate = "git-refs";
              depNameTemplate = "{{{packageName}}}";
              managerFilePatterns = [ "/^pkgs/portproton/package\\.nix$/" ];
              matchStrings = [
                "owner = \"(?<depName>[^\"]+)\";\\s*repo = \"(?<packageName>[^\"]+)\";\\s*rev = \"(?<currentDigest>[a-f0-9]{40})\";"
              ];
              packageNameTemplate = "https://github.com/{{{depName}}}/{{{packageName}}}";
            }
            {
              currentValueTemplate = "master";
              customType = "regex";
              datasourceTemplate = "git-refs";
              depNameTemplate = "{{{packageName}}}";
              managerFilePatterns = [ "/^pkgs/relive/package\\.nix$/" ];
              matchStrings = [
                "owner = \"(?<depName>[^\"]+)\";\\s*repo = \"(?<packageName>[^\"]+)\";\\s*rev = \"(?<currentDigest>[a-f0-9]{40})\";"
              ];
              packageNameTemplate = "https://github.com/{{{depName}}}/{{{packageName}}}";
            }
            {
              customType = "regex";
              datasourceTemplate = "github-tags";
              depNameTemplate = "{{{depName}}}/{{{packageName}}}";
              managerFilePatterns = [ "/^pkgs/.+/package\\.nix$/" ];
              matchStrings = [
                "version = \"(?<currentValue>[^\"]+)\";\\s*src = fetchFromGitHub \\{\\s*owner = \"(?<depName>[^\"]+)\";\\s*repo = \"(?<packageName>[^\"]+)\";\\s*tag = "
              ];
            }
            {
              customType = "regex";
              datasourceTemplate = "github-releases";
              depNameTemplate = "{{{depName}}}/{{{packageName}}}";
              managerFilePatterns = [ "/^pkgs/.+/package\\.nix$/" ];
              matchStrings = [
                "version = \"(?<currentValue>[^\"]+)\";\\s*src = fetch(?:zip|url) \\{\\s*url = \"https://github\\.com/(?<depName>[^/]+)/(?<packageName>[^/]+)/releases/download/"
              ];
            }
          ];
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
          packageRules = [
            {
              matchManagers = [ "custom.regex" ];
              postUpgradeTasks = {
                commands = [ "nix-update --flake -u {{basename packageFileDir}}" ];
                executionMode = "branch";
                fileFilters = [ "pkgs/**" ];
              };
            }
          ];
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
      };
      system.stateVersion = "26.05";
      /*
        virtualisation.quadlet.containers.mister-retroarch-save-sync = {
             autoStart = true;
             containerConfig = {
               autoUpdate = "registry";
               environments = {
                 RETROARCH_CORES = "FCEUmm, Snes9x, Gambatte, mGBA, Genesis Plus GX, Beetle PSX HW, Mupen64Plus-Next";
                 TZ = config.time.timeZone;
               };
               image = "ghcr.io/juaniwck/mister-retroarch-save-sync:latest";
               volumes = [
                 "/mnt/retroarch:/retroarch"
                 "/mnt/mister/saves:/mister/saves"
               ];
             };
             serviceConfig.Restart = "unless-stopped";
           };
      */
    };
}
