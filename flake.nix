# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  description = "Keenan's NixOS configuration";

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    aaru.url = "github:Whovian9369/aaru-nix-flake";
    catppuccin.url = "github:catppuccin/nix";
    catppuccin-ghostwriter = {
      url = "github:catppuccin/ghostwriter";
      flake = false;
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
    catppuccin-xresources = {
      url = "github:catppuccin/xresources";
      flake = false;
    };
    catppuccin-zen = {
      url = "github:catppuccin/zen-browser";
      flake = false;
    };
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    disko.url = "github:nix-community/disko";
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    git-hooks.url = "github:cachix/git-hooks.nix";
    hjem.url = "github:feel-co/hjem";
    home-manager.url = "github:nix-community/home-manager";
    import-tree.url = "github:vic/import-tree";
    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";
    json-sort.url = "github:drupol/json-sort";
    just-one-more-repo.url = "github:ProverbialPennance/just-one-more-repo";
    kwin-effects-kinetic = {
      url = "github:gurrgur/kwin-effects-kinetic";
      flake = false;
    };
    lazyvim.url = "github:pfassina/lazyvim-nix";
    llm-agents.url = "github:numtide/llm-agents.nix";
    lsfg-vk-flake.url = "github:pabloaul/lsfg-vk-flake/main";
    moonshine.url = "github:hgaiser/moonshine";
    niri.url = "github:sodiboo/niri-flake";
    nix-auto-follow = {
      url = "github:fzakaria/nix-auto-follow";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    nix-citizen = {
      url = "github:LovingMelody/nix-citizen";
      inputs.nix-gaming.follows = "nix-gaming";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nix-game-preservation.url = "github:Whovian9369/nix-game-preservation";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-gaming-edge.url = "github:powerofthe69/nix-gaming-edge/nightly";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-podman-stacks.url = "github:Tarow/nix-podman-stacks";
    nix-reshade.url = "github:LovingMelody/nix-reshade";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";
    nixpkgs-lib.follows = "nixpkgs";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-unstable.url = "github:/nixos/nixpkgs/nixpkgs-unstable";
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    noctalia-greeter.url = "github:noctalia-dev/noctalia-greeter";
    nonfree = {
      url = "git+ssh://git@github.com/keenanweaver/nix-nonfree.git?shallow=1";
      flake = false;
    };
    nur.url = "github:nix-community/NUR";
    nur-bandithedoge.url = "github:bandithedoge/nur-packages";
    nvf.url = "github:notashelf/nvf";
    openmw-nix.url = "git+https://codeberg.org/PopeRigby/openmw-nix.git";
    pedantix.url = "github:swarsel/pedantix";
    pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.home-manager.follows = "home-manager";
    };
    preservation.url = "github:nix-community/preservation";
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
    rom-properties.url = "github:Whovian9369/rom-properties-nix-flake";
    simracing-hwdb = {
      url = "github:JacKeTUs/simracing-hwdb";
      flake = false;
    };
    slippi.url = "github:lytedev/slippi-nix";
    sops-nix.url = "github:Mic92/sops-nix";
    steam-config-nix.url = "github:different-name/steam-config-nix";
    systems.url = "github:nix-systems/default-linux";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    ucodenix.url = "github:e-tho/ucodenix";
    umu.url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix";
    wayland-pipewire-idle-inhibit.url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.home-manager.follows = "home-manager";
    };
  };
}
