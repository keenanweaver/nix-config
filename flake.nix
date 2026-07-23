# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  description = "Keenan's NixOS configuration";
  inputs = {
    aaru = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Whovian9369/aaru-nix-flake";
    };
    catppuccin.url = "github:catppuccin/nix";
    catppuccin-ghostwriter = {
      flake = false;
      url = "github:catppuccin/ghostwriter";
    };
    catppuccin-heroic = {
      flake = false;
      url = "github:catppuccin/heroic";
    };
    catppuccin-konsole = {
      flake = false;
      url = "github:catppuccin/konsole";
    };
    catppuccin-obs = {
      flake = false;
      url = "github:catppuccin/obs";
    };
    catppuccin-powershell = {
      flake = false;
      url = "github:catppuccin/powershell";
    };
    catppuccin-xresources = {
      flake = false;
      url = "github:catppuccin/xresources";
    };
    catppuccin-zen = {
      flake = false;
      url = "github:catppuccin/zen-browser";
    };
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    disko = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/disko";
    };
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
      url = "github:hercules-ci/flake-parts";
    };
    git-hooks-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:cachix/git-hooks.nix";
    };
    hjem = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:feel-co/hjem";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    import-tree.url = "github:vic/import-tree";
    jovian = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Jovian-Experiments/Jovian-NixOS";
    };
    just-one-more-repo = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:ProverbialPennance/just-one-more-repo";
    };
    kwin-effects-glass = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:4v3ngR/kwin-effects-glass";
    };
    kwin-effects-kinetic = {
      flake = false;
      url = "github:gurrgur/kwin-effects-kinetic";
    };
    lazyvim.url = "github:pfassina/lazyvim-nix";
    llm-agents.url = "github:numtide/llm-agents.nix";
    lsfg-vk-flake = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:pabloaul/lsfg-vk-flake/main";
    };
    niri = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:sodiboo/niri-flake";
    };
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    nix-citizen = {
      inputs.nix-gaming.follows = "nix-gaming";
      url = "github:LovingMelody/nix-citizen";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
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
    nix-index-database = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Mic92/nix-index-database";
    };
    nix-podman-stacks = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Tarow/nix-podman-stacks";
    };
    nix-reshade = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:LovingMelody/nix-reshade";
    };
    nix-vscode-extensions = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nix-vscode-extensions";
    };
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-lib.follows = "nixpkgs";
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    noctalia-greeter = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:noctalia-dev/noctalia-greeter";
    };
    nonfree = {
      flake = false;
      url = "git+ssh://git@github.com/keenanweaver/nix-nonfree.git?shallow=1";
    };
    nur = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/NUR";
    };
    nur-bandithedoge = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:bandithedoge/nur-packages";
    };
    nvf = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:notashelf/nvf";
    };
    openmw-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "git+https://codeberg.org/PopeRigby/openmw-nix.git";
    };
    pedantix.url = "github:swarsel/pedantix";
    pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";
    plasma-manager = {
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:nix-community/plasma-manager";
    };
    preservation.url = "github:nix-community/preservation";
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
    rom-properties = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Whovian9369/rom-properties-nix-flake";
    };
    simracing-hwdb = {
      flake = false;
      url = "github:JacKeTUs/simracing-hwdb";
    };
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Mic92/sops-nix";
    };
    steam-config-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:different-name/steam-config-nix";
    };
    systems.url = "github:nix-systems/default-linux";
    ucodenix.url = "github:e-tho/ucodenix";
    umu.url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix";
    wayland-pipewire-idle-inhibit = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
    };
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
    zen-browser = {
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:0xc000022070/zen-browser-flake";
    };
  };
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
