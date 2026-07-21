{
  flake.modules = {
    homeManager.gaming-profile =
      {
        config,
        lib,
        pkgs,
        inputs,
        osConfig,
        ...
      }:
      {
        imports = [
          inputs.wayland-pipewire-idle-inhibit.homeModules.default
        ];
        home.sessionVariables = {
          # https://wiki.cachyos.org/configuration/gaming/#increase-maximum-shader-cache-size
          AMD_VULKAN_ICD = "RADV";
          MESA_SHADER_CACHE_MAX_SIZE = "16G";
          RPG2K3_RTP_PATH = "${config.home.homeDirectory}/Games/rpg-maker/RTP/2003";
          RPG2K_RTP_PATH = "${config.home.homeDirectory}/Games/rpg-maker/RTP/2000";
          # https://reddit.com/r/linux_gaming/comments/1mg8vtl/low_latency_gaming_guide/
          SDL_VIDEODRIVER = "wayland,x11"; # SDL2
          SDL_VIDEO_DRIVER = "wayland,x11"; # SDL3
          #ENABLE_LAYER_MESA_ANTI_LAG = 1;
        };
        services = {
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
        xdg.desktopEntries = import ./_desktop-entries.nix {
          inherit
            pkgs
            config
            osConfig
            lib
            ;
        };
      };
    nixos.gaming-profile =
      {
        config,
        inputs,
        ...
      }:
      {
        imports = [
          inputs.just-one-more-repo.nixosModules.default
          inputs.nix-gaming-edge.nixosModules.default
        ];
        boot = {
          extraModulePackages = with config.boot.kernelPackages; [
            zenergy
          ];
          kernel = {
            sysctl = {
              "vm.max_map_count" = 2147483642;
              "vm.mmap_min_addr" = 0; # SheepShaver
            };
          };
          kernelModules = [
            "zenergy"
          ];
          kernelParams = [
            "gpu_sched.sched_policy=0" # https://gitlab.freedesktop.org/drm/amd/-/issues/2516#note_2119750
            "tsc=reliable"
            "clocksource=tsc"
            "preempt=full" # https://reddit.com/r/linux_gaming/comments/1g0g7i0/god_of_war_ragnarok_crackling_audio/lr8j475/?context=3#lr8j475
          ];
        };
        hardware = {
          uinput.enable = true;
          xone.enable = true;
          xpadneo.enable = true;
        };
        nix.settings = {
          extra-substituters = [
            "https://bandithedoge.cachix.org"
            "https://just-one-more-cache.cachix.org/"
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
          inputs.nix-cachyos-kernel.overlays.pinned
        ];
        security = {
          pam = {
            loginLimits = [
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
          };
        };
      };
  };
  flake-file.inputs = {
    aaru = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Whovian9369/aaru-nix-flake";
    };
    jovian = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Jovian-Experiments/Jovian-NixOS";
    };
    just-one-more-repo = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:ProverbialPennance/just-one-more-repo";
    };
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    nix-citizen = {
      inputs.nix-gaming.follows = "nix-gaming";
      url = "github:LovingMelody/nix-citizen";
    };
    nix-game-preservation = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Whovian9369/nix-game-preservation";
    };
    nix-gaming = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:fufexan/nix-gaming";
    };
    nix-gaming-edge = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:powerofthe69/nix-gaming-edge/nightly";
    };
    nix-reshade = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:LovingMelody/nix-reshade";
    };
    nur-bandithedoge = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:bandithedoge/nur-packages";
    };
    openmw-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "git+https://codeberg.org/PopeRigby/openmw-nix.git";
    };
    rom-properties = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Whovian9369/rom-properties-nix-flake";
    };
    simracing-hwdb = {
      flake = false;
      url = "github:JacKeTUs/simracing-hwdb";
    };
    umu.url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix";
    wayland-pipewire-idle-inhibit = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
    };
  };
}
