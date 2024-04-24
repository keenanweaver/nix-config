{
  description = "Keenan's Nix Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    disko = { url = "github:nix-community/disko"; inputs.nixpkgs.follows = "nixpkgs"; };
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    impermanence.url = "github:nix-community/impermanence";
    lanzaboote = { url = "github:nix-community/lanzaboote"; inputs.nixpkgs.follows = "nixpkgs"; };
    plasma-manager = { url = "github:pjones/plasma-manager"; inputs.nixpkgs.follows = "nixpkgs"; inputs.home-manager.follows = "home-manager"; };

    nix-colors.url = "github:misterio77/nix-colors";
    nix-index-database = { url = "github:Mic92/nix-index-database"; inputs.nixpkgs.follows = "nixpkgs"; };
    nix-inspect.url = "github:bluskript/nix-inspect";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nixos-generators = { url = "github:nix-community/nixos-generators"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixvim = { url = "github:nix-community/nixvim"; inputs.nixpkgs.follows = "nixpkgs"; };
    nur.url = "github:nix-community/NUR";
    sops-nix = { url = "github:Mic92/sops-nix"; inputs.nixpkgs.follows = "nixpkgs"; };

    nix-citizen = { url = "github:LovingMelody/nix-citizen"; inputs.nix-gaming.follows = "nix-gaming"; };
    nix-gaming.url = "github:fufexan/nix-gaming";

    cd-ls = { url = "github:zshzoo/cd-ls"; flake = false; };
    gpu-screen-recorder-src = { type = "git"; url = "https://repo.dec05eba.com/gpu-screen-recorder"; flake = false; };
    nonfree = { url = "git+ssh://git@github.com/keenanweaver/nix-nonfree.git?shallow=1"; flake = false; };

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland";
    # Theming
    catppuccin = { url = "github:catppuccin/nix"; };
    catppuccinifier = { url = "github:lighttigerXIV/catppuccinifier"; inputs.nixpkgs.follows = "nixpkgs"; };
    catppuccin-bat = { url = "github:catppuccin/bat"; flake = false; };
    catppuccin-ghostwriter = { url = "github:catppuccin/ghostwriter"; flake = false; };
    catppuccin-halloy = { url = "github:catppuccin/halloy"; flake = false; };
    catppuccin-heroic = { url = "github:catppuccin/heroic"; flake = false; };
    catppuccin-konsole = { url = "github:catppuccin/konsole"; flake = false; };
    catppuccin-kvantum = { url = "github:catppuccin/kvantum"; flake = false; };
    catppuccin-obs = { url = "github:catppuccin/obs"; flake = false; };
    catppuccin-powershell = { url = "github:catppuccin/powershell"; flake = false; };
    catppuccin-xresources = { url = "github:catppuccin/xresources"; flake = false; };

    # KDE
    kwin-effects-forceblur = {
      url = "github:taj-ny/kwin-effects-forceblur";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    homeConfigurations = { };
    nixosConfigurations =
      let
        fullname = "Keenan Weaver";
        username = "keenan";

        dotfiles = ./dotfiles;
      in
      {
        # Desktop
        nixos-desktop = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";

          specialArgs = {
            inherit inputs;
            inherit fullname username dotfiles;

            vars = {
              desktop = true;
              gaming = true;
            };
          };

          modules = with inputs; [

            ./hosts/desktop

            (args: { nixpkgs.overlays = import ./nix/overlays args; })

            catppuccin.nixosModules.catppuccin
            chaotic.nixosModules.default
            disko.nixosModules.disko
            ./hosts/desktop/disko.nix
            {
              _module.args.disks = [ "/dev/nvme0n1" ];
            }
            lanzaboote.nixosModules.lanzaboote
            nur.nixosModules.nur
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit inputs; # Experiment with config and other attributes
                  inherit fullname username dotfiles;

                  vars = {
                    desktop = true;
                    gaming = true;
                  };
                };
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${username} = {
                  home = {
                    # do not change this value
                    stateVersion = "23.11";
                  };
                };
                sharedModules = [
                  catppuccin.homeManagerModules.catppuccin
                  hyprland.homeManagerModules.default
                  nix-colors.homeManagerModules.default
                  nix-index-database.hmModules.nix-index
                  nixvim.homeManagerModules.nixvim
                  nur.hmModules.nur
                  plasma-manager.homeManagerModules.plasma-manager
                  sops-nix.homeManagerModules.sops
                ];
              };
            }
          ];
        };
        # Laptop
        nixos-laptop = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";

          specialArgs = {
            inherit inputs;
            inherit fullname username dotfiles;

            vars = {
              desktop = true;
              gaming = false;
            };
          };

          modules = with inputs; [

            ./hosts/laptop

            (args: { nixpkgs.overlays = import ./nix/overlays args; })

            catppuccin.nixosModules.catppuccin
            chaotic.nixosModules.default
            disko.nixosModules.disko
            ./hosts/desktop/disko.nix
            {
              _module.args.disks = [ "/dev/nvme0n1" ];
            }
            lanzaboote.nixosModules.lanzaboote
            nur.nixosModules.nur
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit inputs;
                  inherit fullname username dotfiles;

                  vars = {
                    desktop = true;
                    gaming = false;
                  };
                };
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${username} = {
                  home = {
                    # do not change this value
                    stateVersion = "23.11";
                  };
                };
                sharedModules = [
                  catppuccin.homeManagerModules.catppuccin
                  hyprland.homeManagerModules.default
                  nix-colors.homeManagerModules.default
                  nix-index-database.hmModules.nix-index
                  nixvim.homeManagerModules.nixvim
                  nur.hmModules.nur
                  plasma-manager.homeManagerModules.plasma-manager
                  sops-nix.homeManagerModules.sops
                ];
              };
            }
          ];
        };
        # Unraid
        nixos-unraid = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";

          specialArgs = {
            inherit inputs;
            inherit fullname username dotfiles;

            vars = {
              desktop = false;
              gaming = false;
            };
          };

          modules = with inputs; [

            ./hosts/vm

            (args: { nixpkgs.overlays = import ./nix/overlays args; })

            catppuccin.nixosModules.catppuccin
            chaotic.nixosModules.default
            disko.nixosModules.disko
            ./hosts/vm/disko.nix
            {
              _module.args.disks = [ "/dev/disk/by-id/virtio-vdisk1" ];
            }
            lanzaboote.nixosModules.lanzaboote
            nur.nixosModules.nur
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit inputs; # Experiment with config and other attributes
                  inherit fullname username dotfiles;

                  vars = {
                    desktop = false;
                    gaming = false;
                  };
                };
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${username} = {
                  home = {
                    # do not change this value
                    stateVersion = "23.11";
                  };
                };
                sharedModules = [
                  catppuccin.homeManagerModules.catppuccin
                  hyprland.homeManagerModules.default
                  nix-colors.homeManagerModules.default
                  nix-index-database.hmModules.nix-index
                  nixvim.homeManagerModules.nixvim
                  nur.hmModules.nur
                  plasma-manager.homeManagerModules.plasma-manager
                  sops-nix.homeManagerModules.sops
                ];
              };
            }
          ];
        };
      };
  };
}
