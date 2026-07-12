{
  flake.modules = {
    homeManager.gaming-profile =
      {
        config,
        lib,
        pkgs,
        osConfig,
        self,
        ...
      }:
      {
        imports = with self.modules.homeManager; [
          steam-config
        ];
        home = {
          file = {
            steam-beta = lib.mkIf (osConfig.networking.hostName != "nixos-htpc") {
              enable = true;
              target = "${config.xdg.dataHome}/Steam/package/beta";
              text = "publicbeta";
            };
          };
          packages = with pkgs; [
            steamcmd
          ];
        };
      };
    homeManager.steam-config = { inputs, ... }: {
      imports = [
        inputs.steam-config-nix.homeModules.default
      ];
      programs.steam.config = {
        enable = true;
        onSteamRunning = "close";
      };
    };
    nixos.gaming-profile =
      { pkgs, inputs, ... }:
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
          extraCompatPackages = with pkgs; [
            inputs.chaotic.legacyPackages.${stdenv.hostPlatform.system}.luxtorpeda
          ];
          localNetworkGameTransfers.openFirewall = true;
          protontricks.enable = true;
          remotePlay.openFirewall = true;
        };
      };
  };
  flake-file.inputs = {
    steam-config-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:different-name/steam-config-nix";
    };
  };
}
