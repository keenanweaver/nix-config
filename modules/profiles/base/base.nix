{ self, ... }:
{
  flake.modules = {
    homeManager.base-profile = { config, ... }: {
      imports = with self.modules.homeManager; [
        catppuccin
      ];

      home = {
        language = {
          base = "en_US.UTF-8";
          collate = "C.UTF-8";
        };
        sessionPath = [
          "${config.home.homeDirectory}/.bin"
          "${config.home.homeDirectory}/.local/bin"
        ];
      };
      xdg = {
        enable = true;
        autostart.enable = true;
        userDirs = {
          enable = true;
          createDirectories = true;
          projects = null;
          publicShare = null;
          setSessionVariables = true;
          templates = null;
        };
      };
    };
    nixos.base-profile = { pkgs, ... }: {
      imports = with self.modules.nixos; [
        local-packages

        catppuccin
      ];

      console.earlySetup = true;

      documentation.man.cache.enable = true;

      environment = {
        homeBinInPath = true;
        localBinInPath = true;
        shells = with pkgs; [
          bash
          zsh
        ];
        stub-ld.enable = true;
      };

      i18n.defaultLocale = "en_US.UTF-8";

      nixpkgs.config = {
        permittedInsecurePackages = [
          "electron-40.10.5" # ?
          "olm-3.2.16" # Neochat
          "pnpm-10.29.2"
          "pnpm-9.15.9" # Decky Loader
        ];
      };

      programs = {
        iotop = {
          enable = true;
        };
      };

      services = {
        earlyoom = {
          enable = true;
          freeMemThreshold = 5;
        };
        journald = {
          extraConfig = ''
            SystemMaxUse=50M
          '';
        };
        logrotate.enable = true;
      };

      systemd = {
        settings.Manager = {
          DefaultTimeoutStartSec = "15s";
          DefaultTimeoutStopSec = "10s";
        };
      };

      time.timeZone = "America/Chicago";
    };
  };
  flake-file = {
    description = "Keenan's NixOS configuration";
  };
}
