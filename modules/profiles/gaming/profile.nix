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
        self,
        inputs,
        config,
        ...
      }:
      {
        imports = [
          inputs.omniflake.flakes.just-one-more-repo.nixosModules.default
          inputs.omniflake.flakes.nix-gaming-edge.nixosModules.default
          inputs.omniflake.flakes.wayland-pipewire-idle-inhibit.nixosModules.default
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
        nix.settings = {
          extra-substituters = [
            "https://bandithedoge.cachix.org"
            "https://just-one-more-cache.cachix.org"
            "https://nix-gaming.cachix.org"
            "https://nix-citizen.cachix.org"
          ];
          extra-trusted-public-keys = [
            "bandithedoge.cachix.org-1:ZtcHw1anyEa4t6H8m3o/ctYFrwYFPAwoENSvofamE6g="
            "just-one-more-cache.cachix.org-1:4nShcKEgcUEVlJqKFrgDwoGfqLnw5KPG4UDTV02jnr4="
            "nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo="
            "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
          ];
        };
        nixpkgs.overlays = [
          inputs.umu.overlays.default
          inputs.omniflake.flakes.nix-cachyos-kernel.overlays.pinned
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
            value = "64556";
          }
        ];
        services.wayland-pipewire-idle-inhibit = {
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
  flake-file.inputs = {
    simracing-hwdb = {
      flake = false;
      url = "github:JacKeTUs/simracing-hwdb";
    };
    umu.url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix";
  };
}
