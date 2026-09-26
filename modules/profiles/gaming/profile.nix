{ self, inputs, ... }:
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
      {
        home.sessionVariables = {
          DXVK_HDR = true;
          LOW_LATENCY_LAYER = true;
          # https://reddit.com/r/linux_gaming/comments/1mg8vtl/low_latency_gaming_guide/
          SDL_VIDEODRIVER = "wayland,x11"; # SDL2
          SDL_VIDEO_DRIVER = "wayland,x11"; # SDL3
          WAYLANDDRV_PRIMARY_MONITOR = osConfig.host.primaryMonitor; # https://reddit.com/r/linux_gaming/comments/1louxm2/fix_for_wine_wayland_using_wrong_monitor/
        };
        xdg.desktopEntries = import ./_desktop-entries.nix {
          inherit
            config
            lib
            osConfig
            pkgs
            ;
        };
      };
    nixos.profile-gaming =
      {
        config,
        ...
      }:
      {
        imports = [
          inputs.just-one-more-repo.nixosModules.default
          inputs.nix-gaming-edge.nixosModules.default
          inputs.wayland-pipewire-idle-inhibit.nixosModules.default
        ];
        assertions = self.lib.mkFactAssertions config [
          "cpu"
          "fpsLimit"
          "gpu"
          "pciDev"
          "primaryMonitor"
          "ztAdapter"
        ];
        boot = {
          kernel.sysctl = {
            "vm.max_map_count" = 2147483642;
            "vm.mmap_min_addr" = 0; # SheepShaver
          };
          kernelParams = [
            "gpu_sched.sched_policy=0" # https://gitlab.freedesktop.org/drm/amd/-/issues/2516#note_2119750
            "tsc=reliable"
            "clocksource=tsc"
            "preempt=full" # https://reddit.com/r/linux_gaming/comments/1g0g7i0/god_of_war_ragnarok_crackling_audio/lr8j475/?context=3#lr8j475
          ];
        };
        home-manager.sharedModules = [ self.modules.homeManager.profile-gaming ];
        nix.settings = {
          extra-substituters = [
            "https://bandithedoge.cachix.org"
            "https://just-one-more-cache.cachix.org"
          ];
          extra-trusted-public-keys = [
            "bandithedoge.cachix.org-1:ZtcHw1anyEa4t6H8m3o/ctYFrwYFPAwoENSvofamE6g="
            "just-one-more-cache.cachix.org-1:4nShcKEgcUEVlJqKFrgDwoGfqLnw5KPG4UDTV02jnr4="
          ];
        };
        nixpkgs.overlays = [
          inputs.umu.overlays.default
        ];
        security.pam.loginLimits = [
          # RPCS3
          {
            domain = "*";
            item = "memlock";
            type = "hard";
            value = "unlimited";
          }
          # RPCS3
          {
            domain = "*";
            item = "memlock";
            type = "soft";
            value = "unlimited";
          }
          {
            domain = "*";
            item = "nofile";
            type = "-";
            value = "2097152";
          }
          {
            domain = "*";
            item = "nofile";
            type = "soft";
            value = "65536";
          }
        ];
        services = {
          irqbalance.enable = true;
          wayland-pipewire-idle-inhibit = {
            enable = true;
            settings = {
              idle_inhibitor = "d-bus";
              media_minimum_duration = 5;
              sink_whitelist = [
                { name = "Browser"; }
                { name = "Game"; }
                { name = "Music"; }
              ];
              verbosity = "WARN";
            };
          };
        };
      };
  };
  flake-file.inputs = {
    just-one-more-repo = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:ProverbialPennance/just-one-more-repo";
    };
    umu = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix";
    };
    wayland-pipewire-idle-inhibit = {
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
      url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
    };
  };
}
