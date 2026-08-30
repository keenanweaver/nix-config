{
  flake.modules = {
    homeManager = {
      profile-gaming =
        {
          self,
          lib,
          config,
          pkgs,
          osConfig,
          ...
        }:
        {
          imports = with self.modules.homeManager; [
            steam-config
          ];
          home = {
            file.steam-beta = lib.mkIf (osConfig.networking.hostName != "nixos-htpc") {
              enable = true;
              target = "${config.xdg.dataHome}/Steam/package/beta";
              text = "publicbeta";
            };
            packages = with pkgs; [
              steamcmd
            ];
          };
        };
      steam-config =
        { inputs, ... }:
        {
          imports = [
            inputs.omniflake.flakes.steam-config-nix.homeModules.default
          ];
          programs.steam.config = {
            enable = true;
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
}
