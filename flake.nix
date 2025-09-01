{
  description = "Keenan's Nix Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-yazi-plugins = {
      url = "github:lordkekz/nix-yazi-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf.url = "github:notashelf/nvf";
    quadlet-nix = {
      url = "github:SEIAROTg/quadlet-nix";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cd-ls = {
      url = "github:zshzoo/cd-ls";
      flake = false;
    };
    ucodenix.url = "github:e-tho/ucodenix";

    # Gaming
    aaru = {
      url = "github:Whovian9369/aaru-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lsfg-vk-flake = {
      url = "github:pabloaul/lsfg-vk-flake/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-game-preservation = {
      url = "github:Whovian9369/nix-game-preservation";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rom-properties = {
      url = "github:Whovian9369/rom-properties-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    just-one-more-repo = {
      url = "github:ProverbialPennance/just-one-more-repo";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wayland-pipewire-idle-inhibit = {
      url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-citizen = {
      url = "github:LovingMelody/nix-citizen";
      inputs.nix-gaming.follows = "nix-gaming";
    };
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-reshade.url = "github:LovingMelody/nix-reshade";
    nonfree = {
      url = "git+ssh://git@github.com/keenanweaver/nix-nonfree.git?shallow=1";
      flake = false;
    };
    openmw-nix = {
      url = "git+https://codeberg.org/PopeRigby/openmw-nix.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    simracing-hwdb = {
      url = "github:JacKeTUs/simracing-hwdb";
      flake = false;
    };
    umu.url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix";

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
    klassy = {
      url = "github:dshatz/klassy-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lightly.url = "github:Bali10050/Darkly";

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
          username = "deck";
          home = "/home/deck";
        in
        {
          steamdeck = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            modules = with inputs; [
              ./hosts/steamdeck/home.nix
              catppuccin.homeModules.catppuccin
              impermanence.homeManagerModules.impermanence
              nix-flatpak.homeManagerModules.nix-flatpak
              nur.modules.homeManager.default
              plasma-manager.homeModules.plasma-manager
              sops-nix.homeManagerModules.sops
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
        in
        {
          # Desktop
          nixos-desktop = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";

            specialArgs = {
              inherit inputs;
              inherit fullname username;

              vars = {
                desktop = true;
                gaming = true;
              };
            };

            modules = with inputs; [

              ./hosts/desktop

              catppuccin.nixosModules.catppuccin
              chaotic.nixosModules.default
              disko.nixosModules.disko
              ./hosts/desktop/disko.nix
              { _module.args.disks = [ "/dev/disk/by-id/nvme-CT2000T700SSD3_2413E8A197BB" ]; }
              impermanence.nixosModules.impermanence
              just-one-more-repo.nixosModules.default
              lsfg-vk-flake.nixosModules.default
              nix-flatpak.nixosModules.nix-flatpak
              nur.modules.nixos.default
              sops-nix.nixosModules.sops
              ucodenix.nixosModules.default
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  backupFileExtension = "hmbak";
                  useUserPackages = true;
                  extraSpecialArgs = {
                    inherit inputs; # Experiment with config and other attributes
                    inherit fullname username;

                    vars = {
                      desktop = true;
                      gaming = true;
                    };
                  };
                  sharedModules = with inputs; [
                    catppuccin.homeModules.catppuccin
                    impermanence.homeManagerModules.impermanence
                    nix-flatpak.homeManagerModules.nix-flatpak
                    nix-index-database.homeModules.nix-index
                    nur.modules.homeManager.default
                    nvf.homeManagerModules.default
                    plasma-manager.homeModules.plasma-manager
                    sops-nix.homeManagerModules.sops
                    wayland-pipewire-idle-inhibit.homeModules.default
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
              inherit fullname username;

              vars = {
                desktop = true;
                gaming = false;
              };
            };

            modules = with inputs; [

              ./hosts/laptop

              catppuccin.nixosModules.catppuccin
              chaotic.nixosModules.default
              disko.nixosModules.disko
              ./hosts/laptop/disko.nix
              { _module.args.disks = [ "/dev/disk/by-id/nvme-eui.5cd2e48231514cb8" ]; }
              impermanence.nixosModules.impermanence
              just-one-more-repo.nixosModules.default
              nix-flatpak.nixosModules.nix-flatpak
              nur.modules.nixos.default
              sops-nix.nixosModules.sops
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  extraSpecialArgs = {
                    inherit inputs;
                    inherit fullname username;

                    vars = {
                      desktop = true;
                      gaming = false;
                    };
                  };
                  useUserPackages = true;
                  users.${username} = {
                    home = {
                      # do not change this value
                      stateVersion = "23.11";
                    };
                  };
                  sharedModules = with inputs; [
                    catppuccin.homeModules.catppuccin
                    impermanence.homeManagerModules.impermanence
                    nix-flatpak.homeManagerModules.nix-flatpak
                    nix-index-database.homeModules.nix-index
                    nur.modules.homeManager.default
                    nvf.homeManagerModules.default
                    plasma-manager.homeModules.plasma-manager
                    sops-nix.homeManagerModules.sops
                  ];
                };
              }
            ];
          };
          # Pi
          remorsepi = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";

            specialArgs = {
              inherit inputs;
              inherit fullname username;

              vars = {
                desktop = false;
                gaming = false;
              };
            };

            modules = with inputs; [

              ./hosts/pi/remorse.nix

              chaotic.nixosModules.default
              impermanence.nixosModules.impermanence
              nix-flatpak.nixosModules.nix-flatpak
              nixos-hardware.nixosModules.raspberry-pi-4
              nur.modules.nixos.default
              quadlet-nix.nixosModules.quadlet
              sops-nix.nixosModules.sops
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  extraSpecialArgs = {
                    inherit inputs; # Experiment with config and other attributes
                    inherit fullname username;

                    vars = {
                      desktop = false;
                      gaming = false;
                    };
                  };
                  useUserPackages = true;
                  users.${username} = {
                    home = {
                      # do not change this value
                      stateVersion = "23.11";
                    };
                  };
                  sharedModules = with inputs; [
                    impermanence.homeManagerModules.impermanence
                    nix-flatpak.homeManagerModules.nix-flatpak
                    nix-index-database.homeModules.nix-index
                    nur.modules.homeManager.default
                    quadlet-nix.homeManagerModules.quadlet
                    sops-nix.homeManagerModules.sops
                  ];
                };
              }
            ];
          };
          regretpi = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";

            specialArgs = {
              inherit inputs;
              inherit fullname username;

              vars = {
                desktop = false;
                gaming = false;
              };
            };

            modules = with inputs; [

              ./hosts/pi/regret.nix

              catppuccin.nixosModules.catppuccin
              chaotic.nixosModules.default
              impermanence.nixosModules.impermanence
              nix-flatpak.nixosModules.nix-flatpak
              nixos-hardware.nixosModules.raspberry-pi-4
              nur.modules.nixos.default
              quadlet-nix.nixosModules.quadlet
              sops-nix.nixosModules.sops
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  backupFileExtension = "hmbak";
                  useUserPackages = true;
                  extraSpecialArgs = {
                    inherit inputs; # Experiment with config and other attributes
                    inherit fullname username;

                    vars = {
                      desktop = false;
                      gaming = false;
                    };
                  };
                  sharedModules = with inputs; [
                    catppuccin.homeModules.catppuccin
                    impermanence.homeManagerModules.impermanence
                    nix-flatpak.homeManagerModules.nix-flatpak
                    nix-index-database.homeModules.nix-index
                    nur.modules.homeManager.default
                    nvf.homeManagerModules.default
                    plasma-manager.homeModules.plasma-manager
                    quadlet-nix.homeManagerModules.quadlet
                    sops-nix.homeManagerModules.sops
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
              inherit fullname username;

              vars = {
                desktop = false;
                gaming = false;
              };
            };

            modules = with inputs; [

              ./hosts/vm

              catppuccin.nixosModules.catppuccin
              chaotic.nixosModules.default
              disko.nixosModules.disko
              ./hosts/vm/disko.nix
              { _module.args.disks = [ "/dev/disk/by-id/virtio-vdisk1" ]; }
              impermanence.nixosModules.impermanence
              nix-flatpak.nixosModules.nix-flatpak
              nur.modules.nixos.default
              sops-nix.nixosModules.sops
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  extraSpecialArgs = {
                    inherit inputs; # Experiment with config and other attributes
                    inherit fullname username;

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
                  sharedModules = with inputs; [
                    catppuccin.homeModules.catppuccin
                    impermanence.homeManagerModules.impermanence
                    nix-flatpak.homeManagerModules.nix-flatpak
                    nix-index-database.homeModules.nix-index
                    nur.modules.homeManager.default
                    nvf.homeManagerModules.default
                    plasma-manager.homeModules.plasma-manager
                    sops-nix.homeManagerModules.sops
                  ];
                };
              }
            ];
          };
        };
    };
}
