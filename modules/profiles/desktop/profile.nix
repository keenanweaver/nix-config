{
  self,
  inputs,
  ...
}:
{
  flake.modules = {
    homeManager.profile-desktop = {
      imports = with self.modules.homeManager; [
        zen-browser
      ];
      xdg = {
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
    nixos.profile-desktop =
      {
        pkgs,
        ...
      }:
      {
        imports = with self.modules.nixos; [
          profile-base
          btrfs
        ];
        console = {
          font = "ter-v28b";
          packages = with pkgs; [
            terminus_font
          ];
        };
        environment.sessionVariables = {
          ELECTRON_OZONE_PLATFORM_HINT = "wayland";
          NIXOS_OZONE_WL = "1";
        };
        hardware = {
          facter.detected.dhcp.enable = false;
          graphics = {
            enable = true;
            enable32Bit = true;
          };
        };
        home-manager.sharedModules = [ self.modules.homeManager.profile-desktop ];
        my.permittedInsecurePackages = [ "olm-3.2.16" ]; # Neochat
        nix.settings = {
          extra-substituters = [
            "https://nix-cache.tokidoki.dev/tokidoki"
          ];
          extra-trusted-public-keys = [
            "tokidoki:MD4VWt3kK8Fmz3jkiGoNRJIW31/QAm7l1Dcgz2Xa4hk="
          ];
        };
        nixpkgs.overlays = [ inputs.nix-gaming-edge.overlays.default ];
        programs = {
          appimage = {
            enable = true;
            binfmt = true;
          };
          ydotool.enable = true;
        };
        services = {
          fwupd.enable = true;
          tuned = {
            enable = true;
            ppdSettings.profiles = {
              balanced = "balanced";
              performance = "throughput-performance";
              power-saver = "desktop-powersave";
            };
            settings.dynamic_tuning = true;
          };
        };
        xdg.mime =
          let
            browser = "zen-beta.desktop";
          in
          {
            enable = true;
            defaultApplications = {
              "application/xhtml+xml" = browser;
              "text/html" = browser;
              "x-scheme-handler/http" = browser;
              "x-scheme-handler/https" = browser;
              "x-scheme-handler/terminal" = "org.wezfurlong.wezterm.desktop";
            };
          };
      };
  };
}
