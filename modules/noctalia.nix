{
  flake.modules = {
    homeManager.noctalia = { inputs, ... }: {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      programs.noctalia = {
        enable = true;
        settings = {
          theme = {
            builtin = "Catppuccin";
            mode = "dark";
            source = "builtin";
          };
          wallpaper = {
            default.path = "/path/to/wallpapers/wallpaper.png";
            enabled = true;
          };
        };
      };
    };
    nixos.noctalia = { pkgs, inputs, ... }: {
      imports = [
        inputs.noctalia.nixosModules.default
        inputs.noctalia-greeter.nixosModules.default
      ];
      nix.settings = {
        extra-substituters = [ "https://noctalia.cachix.org" ];
        extra-trusted-public-keys = [
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];
      };
      programs = {
        noctalia = {
          enable = true;
          recommendedServices.enable = true;
        };
        noctalia-greeter = {
          enable = true;
          # Optional configuration
          greeter-args = "";
          settings = {
            cursor = {
              path = "${pkgs.bibata-cursors}/share/icons";
              size = 24;
              theme = "Bibata-Modern-Ice";
            };
            keyboard = {
              layout = "us";
            };
          };
        };
      };
    };
  };
  flake-file.inputs = {
    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
    };
    noctalia-greeter = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:noctalia-dev/noctalia-greeter";
    };
  };
}
