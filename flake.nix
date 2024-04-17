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

    nh = { url = "github:viperML/nh"; inputs.nixpkgs.follows = "nixpkgs"; };
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
    #yazi.url = "github:sxyazi/yazi";

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland";
    /*     hyprland-plugins = { url = "github:hyprwm/hyprland-plugins"; inputs.hyprland.follows = ""; };
      hyprlock.url = "github:hyprwm/hyprlock";
      hyprpaper.url = "github:hyprwm/hyprpaper";
      hyprpicker.url = "github:hyprwm/hyprpicker";
     */
    # Theming
    catppuccin = { url = "github:catppuccin/nix"; };
    catppuccinifier = { url = "github:lighttigerXIV/catppuccinifier"; inputs.nixpkgs.follows = "nixpkgs"; };
    #catppuccin-alacritty = { url = "github:catppuccin/alacritty"; flake = false; };
    catppuccin-bat = { url = "github:catppuccin/bat"; flake = false; };
    #catppuccin-btop = { url = "github:catppuccin/btop"; flake = false; };
    #catppuccin-delta = { url = "github:catppuccin/delta"; flake = false; };
    catppuccin-ghostwriter = { url = "github:catppuccin/ghostwriter"; flake = false; };
    catppuccin-halloy = { url = "github:catppuccin/halloy"; flake = false; };
    #catppuccin-helix = { url = "github:catppuccin/helix"; flake = false; };
    catppuccin-heroic = { url = "github:catppuccin/heroic"; flake = false; };
    #catppuccin-hyprland = { url = "github:catppuccin/hyprland"; flake = false; };
    catppuccin-konsole = { url = "github:catppuccin/konsole"; flake = false; };
    catppuccin-kvantum = { url = "github:catppuccin/kvantum"; flake = false; };
    #catppuccin-micro = { url = "github:catppuccin/micro"; flake = false; };
    catppuccin-obs = { url = "github:catppuccin/obs"; flake = false; };
    catppuccin-powershell = { url = "github:catppuccin/powershell"; flake = false; };
    #catppuccin-starship = { url = "github:catppuccin/starship"; flake = false; };
    catppuccin-xresources = { url = "github:catppuccin/xresources"; flake = false; };
    #catppuccin-yazi = { url = "github:catppuccin/yazi"; flake = false; };

    # KDE
    /*     kde-plasmoid-configurable-button = { url = "github:doncsugar/plasmoid-button/plasma6"; flake = false; };
    kde-plasmoid-wunderground = { url = "github:k-donn/plasmoid-wunderground/plasma6-release"; flake = false; }; */
    /*     kde-plasmoid-tiled-menu = {
      url = "github:Zren/plasma-applet-tiledmenu";
      flake = false;
    }; */
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
          };

          modules = [

            ./hosts/desktop

            (args: { nixpkgs.overlays = import ./nix/overlays args; })

            inputs.catppuccin.nixosModules.catppuccin
            inputs.chaotic.nixosModules.default
            inputs.disko.nixosModules.disko
            ./hosts/desktop/disko.nix
            {
              _module.args.disks = [ "/dev/nvme0n1" ];
            }
            inputs.lanzaboote.nixosModules.lanzaboote
            inputs.nur.nixosModules.nur
            inputs.sops-nix.nixosModules.sops
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit inputs;
                  inherit fullname username dotfiles;
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
        # Laptop
        nixos-laptop = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";

          specialArgs = {
            inherit inputs;
            inherit fullname username dotfiles;
          };

          modules = [

            ./hosts/laptop

            (args: { nixpkgs.overlays = import ./nix/overlays args; })

            inputs.catppuccin.nixosModules.catppuccin
            inputs.chaotic.nixosModules.default
            inputs.disko.nixosModules.disko
            ./hosts/desktop/disko.nix
            {
              _module.args.disks = [ "/dev/nvme0n1" ];
            }
            inputs.lanzaboote.nixosModules.lanzaboote
            inputs.nur.nixosModules.nur
            inputs.sops-nix.nixosModules.sops
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit inputs;
                  inherit fullname username dotfiles;
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
