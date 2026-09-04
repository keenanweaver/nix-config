# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  description = "Keenan's NixOS configuration";

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  nixConfig = {
    extra-experimental-features = [
      "flakes"
      "nix-command"
      "pipe-operators"
    ];
  };

  inputs = {
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
    flake-file.url = "github:denful/flake-file";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    import-tree.url = "github:denful/import-tree";
    json-sort = {
      url = "github:drupol/json-sort";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kwin-effects-kinetic = {
      url = "github:gurrgur/kwin-effects-kinetic";
      flake = false;
    };
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nonfree = {
      url = "git+https://github.com/keenanweaver/nix-nonfree.git?shallow=1";
      flake = false;
    };
    omniflake = {
      url = "github:fzakaria/omniflake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    openmw-nix = {
      url = "git+https://codeberg.org/PopeRigby/openmw-nix.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    simracing-hwdb = {
      url = "github:JacKeTUs/simracing-hwdb";
      flake = false;
    };
    systems.url = "github:nix-systems/default-linux";
    umu.url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix";
  };
}
