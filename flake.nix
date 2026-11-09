# DO-NOT-EDIT. This file was auto-generated using github:denful/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  description = "Keenan's NixOS configuration";

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    aaru-nix-flake = {
      url = "github:Whovian9369/aaru-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cachyos-settings-nix = {
      url = "github:Daaboulex/cachyos-settings-nix";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin-heroic = {
      url = "github:catppuccin/heroic";
      flake = false;
    };
    catppuccin-konsole = {
      url = "github:catppuccin/konsole";
      flake = false;
    };
    catppuccin-obs = {
      url = "github:catppuccin/obs";
      flake = false;
    };
    catppuccin-powershell = {
      url = "github:catppuccin/powershell";
      flake = false;
    };
    coolercontrol-nix = {
      url = "github:Daaboulex/coolercontrol-nix";
      inputs = {
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks-nix";
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-file.url = "github:denful/flake-file";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    gamesir = {
      url = "git+https://codeberg.org/Epaphroditus/gamesir-linux-tools-nix.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
      };
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    import-tree.url = "github:denful/import-tree";
    just-one-more-repo.url = "github:ProverbialPennance/just-one-more-repo";
    kwin-effects-better-blur-dx = {
      url = "github:xarblu/kwin-effects-better-blur-dx";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kwin-effects-kinetic = {
      url = "github:gurrgur/kwin-effects-kinetic";
      flake = false;
    };
    laminix = {
      url = "github:jackboykin/laminix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lazyvim-nix = {
      url = "github:pfassina/lazyvim-nix";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };
    llm-agents-nix = {
      url = "github:numtide/llm-agents.nix";
      inputs = {
        flake-parts.follows = "flake-parts";
        systems.follows = "flake-utils/systems";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    lsfg-vk-nix = {
      url = "github:Daaboulex/lsfg-vk-nix";
      inputs = {
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks-nix";
        nixpkgs.follows = "nixpkgs";
      };
    };
    moonshine = {
      url = "github:hgaiser/moonshine";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
      };
    };
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nix-gaming-edge.url = "github:powerofthe69/nix-gaming-edge";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-mineral = {
      url = "github:cynicsketch/nix-mineral";
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
    nix-podman-stacks = {
      url = "github:Tarow/nix-podman-stacks";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };
    nix-reshade = {
      url = "github:LovingMelody/nix-reshade";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixdatifier = {
      url = "github:Muddyblack/nixdatifier";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-mocha-kde-splash = {
      url = "github:michaelwheatland/nixos-mocha-kde-splash";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-plymouth = {
      url = "github:iltgg/nixos_plymouth";
      inputs = {
        nixos-branding.inputs = {
          flake-compat.follows = "flake-compat";
          pre-commit-hooks.follows = "git-hooks-nix";
          treefmt-nix.follows = "treefmt-nix";
        };
        nixpkgs.follows = "nixpkgs";
      };
    };
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
    nixos-steam = {
      url = "github:parzivale/nixos-steam";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
    nixpkgs-lib.follows = "nixpkgs";
    nixpkgs-patch-amethyst-mod-manager-bump = {
      url = "https://github.com/NixOS/nixpkgs/compare/faaab5b83d240c3359b9ac92ce6dbd017ba64014...6243396467aff62c9df8d29907b4f92058c094a4.diff";
      flake = false;
    };
    nixpkgs-patch-gpu-screen-recorder-modernize = {
      url = "https://github.com/NixOS/nixpkgs/compare/9a3c97c772303c3987767e448ddd928294bdaf11...74b89c527c44b19c7396d7686412dab882c7aee7.diff";
      flake = false;
    };
    nixpkgs-patch-heroic-modernize = {
      url = "https://github.com/NixOS/nixpkgs/pull/584805.diff";
      flake = false;
    };
    nixpkgs-patch-luxtorpeda-bin = {
      url = "https://github.com/NixOS/nixpkgs/pull/585753.diff";
      flake = false;
    };
    nixpkgs-patch-openxcom-extended-init = {
      url = "https://github.com/NixOS/nixpkgs/pull/575042.diff";
      flake = false;
    };
    nixpkgs-patch-topgrade-system-aws-lc = {
      url = "https://github.com/NixOS/nixpkgs/pull/585019.diff";
      flake = false;
    };
    nixpkgs-patcher.url = "github:gepbird/nixpkgs-patcher";
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    nonfree = {
      url = "github:keenanweaver/nix-nonfree";
      flake = false;
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
    nur-packages-bandithedoge = {
      url = "github:bandithedoge/nur-packages";
      inputs.flake-parts.follows = "flake-parts";
    };
    nyx = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.home-manager.follows = "home-manager";
    };
    openmw-nix = {
      url = "git+https://codeberg.org/PopeRigby/openmw-nix.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pedantix = {
      url = "github:Swarsel/pedantix";
      inputs = {
        flake-parts.follows = "flake-parts";
        git-hooks-nix.follows = "git-hooks-nix";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };
    preservation.url = "github:nix-community/preservation";
    proton-cachyos-nix = {
      url = "github:Daaboulex/proton-cachyos-nix";
      inputs = {
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks-nix";
        nixpkgs.follows = "nixpkgs";
      };
    };
    proton-ge-nix = {
      url = "github:Daaboulex/proton-ge-nix";
      inputs = {
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks-nix";
        nixpkgs.follows = "nixpkgs";
      };
    };
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
    rom-properties-nix-flake = {
      url = "github:Whovian9369/rom-properties-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    simracing-hwdb = {
      url = "github:JacKeTUs/simracing-hwdb";
      flake = false;
    };
    slippi-nix = {
      url = "github:lytedev/slippi-nix";
      inputs = {
        git-hooks.follows = "git-hooks-nix";
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    streamcontroller-nix = {
      url = "github:Daaboulex/streamcontroller-nix";
      inputs = {
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks-nix";
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ucodenix.url = "github:e-tho/ucodenix";
    umu = {
      url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    volt-gui-nix = {
      url = "github:keygenesis/volt-gui-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wayland-pipewire-idle-inhibit = {
      url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "flake-utils/systems";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    wine-cachyos-nix = {
      url = "github:Daaboulex/wine-cachyos-nix";
      inputs = {
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks-nix";
        nixpkgs.follows = "nixpkgs";
      };
    };
    yeetmouse-nix = {
      url = "github:Daaboulex/yeetmouse-nix";
      inputs = {
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks-nix";
        nixpkgs.follows = "nixpkgs";
      };
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };
}
