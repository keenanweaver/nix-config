{
  description = "Keenan's Nix Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.05";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nix-colors.url = "github:misterio77/nix-colors";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-inspect.url = "github:bluskript/nix-inspect";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-citizen = {
      url = "github:LovingMelody/nix-citizen";
      inputs.nix-gaming.follows = "nix-gaming";
    };
    nix-gaming.url = "github:fufexan/nix-gaming";

    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cd-ls = {
      url = "github:zshzoo/cd-ls";
      flake = false;
    };
    /*
      gpu-screen-recorder-src = {
         type = "git";
         url = "https://repo.dec05eba.com/gpu-screen-recorder";
         flake = false;
       };
    */
    nonfree = {
      url = "git+ssh://git@github.com/keenanweaver/nix-nonfree.git?shallow=1";
      flake = false;
    };
    nsearch = {
      url = "github:niksingh710/nsearch";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    /*
      ow-mod-man = {
         url = "github:ow-mods/ow-mod-man";
         inputs.nixpkgs.follows = "nixpkgs";
       };
    */
    steamtinkerlaunch-master = {
      type = "git";
      url = "https://github.com/sonic2kk/steamtinkerlaunch.git";
      flake = false;
    };

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland";

    # Theming
    catppuccin = {
      url = "github:catppuccin/nix";
    };
    catppuccin-ghostwriter = {
      url = "github:catppuccin/ghostwriter";
      flake = false;
    };
    catppuccin-halloy = {
      url = "github:catppuccin/halloy";
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
      url = "github:IAmJafeth/zen-browser";
      flake = false;
    };
    #stylix.url = "github:danth/stylix";

    # KDE
    kwin-effects-forceblur = {
      url = "github:taj-ny/kwin-effects-forceblur";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kwin-effects-kinetic = {
      url = "github:gurrgur/kwin-effects-kinetic";
      flake = false;
    };
  };
  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    {
      homeConfigurations =
        let
          fullname = "Keenan Weaver";
          username = "deck";
          home = "/home/deck";
          dotfiles = ./dotfiles;
        in
        {
          steamdeck = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = [
              ./hosts/steamdeck/home.nix
              inputs.catppuccin.homeManagerModules.catppuccin
              inputs.nix-colors.homeManagerModules.default
              inputs.nix-flatpak.homeManagerModules.nix-flatpak
              inputs.nur.hmModules.nur
              inputs.plasma-manager.homeManagerModules.plasma-manager
              inputs.sops-nix.homeManagerModules.sops
            ];

            extraSpecialArgs = {
              inherit inputs;
              username = username;
              home = home;
            };
            users.${username} = {
              home = {
                stateVersion = "23.11";
              };
            };
            useGlobalPkgs = true;
            useUserPackages = true;
          };
        };
      nixosConfigurations =
        let
          fullname = "Keenan Weaver";
          username = "keenan";

          dotfiles = ./dotfiles;
        in
        {
          # Desktop
          nixos-desktop = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";

            specialArgs = {
              inherit inputs;
              inherit fullname username dotfiles;

              vars = {
                desktop = true;
                gaming = true;
                nvidia = false;
              };
            };

            modules = [

              ./hosts/desktop

              inputs.catppuccin.nixosModules.catppuccin
              inputs.chaotic.nixosModules.default
              inputs.disko.nixosModules.disko
              ./hosts/desktop/disko.nix
              { _module.args.disks = [ "/dev/disk/by-id/nvme-CT2000T700SSD3_2413E8A197BB" ]; }
              inputs.lanzaboote.nixosModules.lanzaboote
              inputs.nix-flatpak.nixosModules.nix-flatpak
              inputs.nur.nixosModules.nur
              inputs.sops-nix.nixosModules.sops
              #inputs.stylix.nixosModules.stylix
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  backupFileExtension = "hmbak";
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = {
                    inherit inputs; # Experiment with config and other attributes
                    inherit fullname username dotfiles;

                    vars = {
                      desktop = true;
                      gaming = true;
                    };
                  };
                  sharedModules = with inputs; [
                    catppuccin.homeManagerModules.catppuccin
                    #hyprland.homeManagerModules.default
                    nix-colors.homeManagerModules.default
                    nix-flatpak.homeManagerModules.nix-flatpak
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
          nixos-laptop = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";

            specialArgs = {
              inherit inputs;
              inherit fullname username dotfiles;

              vars = {
                desktop = true;
                gaming = false;
                nvidia = false;
              };
            };

            modules = [

              ./hosts/laptop

              inputs.auto-cpufreq.nixosModules.default
              inputs.catppuccin.nixosModules.catppuccin
              inputs.chaotic.nixosModules.default
              inputs.disko.nixosModules.disko
              ./hosts/desktop/disko.nix
              { _module.args.disks = [ "/dev/nvme0n1" ]; }
              inputs.lanzaboote.nixosModules.lanzaboote
              inputs.nix-flatpak.nixosModules.nix-flatpak
              inputs.nur.nixosModules.nur
              inputs.sops-nix.nixosModules.sops
              #inputs.stylix.nixosModules.stylix
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
                    inputs.catppuccin.homeManagerModules.catppuccin
                    inputs.hyprland.homeManagerModules.default
                    inputs.nix-colors.homeManagerModules.default
                    inputs.nix-flatpak.homeManagerModules.nix-flatpak
                    inputs.nix-index-database.hmModules.nix-index
                    inputs.nixvim.homeManagerModules.nixvim
                    inputs.nur.hmModules.nur
                    inputs.plasma-manager.homeManagerModules.plasma-manager
                    inputs.sops-nix.homeManagerModules.sops
                  ];
                };
              }
            ];
          };
          # Pi
          remorse = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";

            specialArgs = {
              inherit inputs;
              inherit fullname username dotfiles;

              vars = {
                desktop = false;
                gaming = false;
              };
            };

            modules = [

              ./hosts/pi/remorse.nix

              inputs.chaotic.nixosModules.default
              inputs.lanzaboote.nixosModules.lanzaboote
              inputs.nix-flatpak.nixosModules.nix-flatpak
              inputs.nur.nixosModules.nur
              inputs.sops-nix.nixosModules.sops
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
                    inputs.nix-flatpak.homeManagerModules.nix-flatpak
                    inputs.nix-index-database.hmModules.nix-index
                    inputs.nixvim.homeManagerModules.nixvim
                    inputs.nur.hmModules.nur
                    inputs.sops-nix.homeManagerModules.sops
                  ];
                };
              }
            ];
          };
          # Unraid
          nixos-unraid = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";

            specialArgs = {
              inherit inputs;
              inherit fullname username dotfiles;

              vars = {
                desktop = false;
                gaming = false;
              };
            };

            modules = [

              ./hosts/vm

              inputs.catppuccin.nixosModules.catppuccin
              inputs.chaotic.nixosModules.default
              inputs.disko.nixosModules.disko
              ./hosts/vm/disko.nix
              { _module.args.disks = [ "/dev/disk/by-id/virtio-vdisk1" ]; }
              inputs.lanzaboote.nixosModules.lanzaboote
              inputs.nix-flatpak.nixosModules.nix-flatpak
              inputs.nur.nixosModules.nur
              inputs.sops-nix.nixosModules.sops
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
                    inputs.catppuccin.homeManagerModules.catppuccin
                    inputs.hyprland.homeManagerModules.default
                    inputs.nix-colors.homeManagerModules.default
                    inputs.nix-flatpak.homeManagerModules.nix-flatpak
                    inputs.nix-index-database.hmModules.nix-index
                    inputs.nixvim.homeManagerModules.nixvim
                    inputs.nur.hmModules.nur
                    inputs.plasma-manager.homeManagerModules.plasma-manager
                    inputs.sops-nix.homeManagerModules.sops
                  ];
                };
              }
            ];
          };
        };
    };
}
