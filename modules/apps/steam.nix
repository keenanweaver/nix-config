{
  flake.modules = {
    homeManager = {
      profile-gaming =
        {
          self,
          lib,
          config,
          pkgs,
          ...
        }:
        {
          imports = with self.modules.homeManager; [
            steam-config
          ];
          config.home = {
            file.steam-beta = lib.mkIf config.my.steam.publicBeta {
              target = "${config.xdg.dataHome}/Steam/package/beta";
              text = "publicbeta";
            };
            packages = with pkgs; [
              steamcmd
            ];
          };
          options.my.steam.publicBeta = lib.mkOption {
            default = true;
            description = "Opt the Steam client into the public beta branch.";
            type = lib.types.bool;
          };
        };
      steam-config =
        { inputs, lib, ... }:
        {
          imports = [
            inputs.steam-config-nix.homeModules.default
          ];
          programs.steam.config = {
            enable = true;
            apps."993090" = {
              betaBranch = "lsfg-vk";
              name = "Lossless Scaling";
            };
            defaultCompatTool = lib.mkForce "Proton-CachyOS Latest";
            displayRatesAsBits = false;
            notifications = true;
            onSteamRunning = "close";
          };
        };
    };
    nixos.profile-gaming =
      { pkgs, ... }:
      {
        programs.steam = {
          enable = true;
          package = pkgs.steam.override {
            extraEnv = {
              PIPEWIRE_NODE = "Game";
              PROTON_ENABLE_WAYLAND = true;
              PULSE_SINK = "Game";
            };
            # https://github.com/NixOS/nixpkgs/issues/279893#issuecomment-2425213386
            extraProfile = ''
              unset TZ
            '';
            privateTmp = false; # https://github.com/NixOS/nixpkgs/issues/381923
          };
          extraCompatPackages = with pkgs; [ luxtorpeda ];
          localNetworkGameTransfers.openFirewall = true;
          protontricks.enable = true;
          remotePlay.openFirewall = true;
        };
      };
  };
  flake-file.inputs.steam-config-nix = {
    inputs = {
      nixpkgs.follows = "nixpkgs";
      systems.follows = "systems";
    };
    url = "github:different-name/steam-config-nix";
  };
}
