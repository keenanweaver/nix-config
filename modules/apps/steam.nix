{ self, inputs, ... }:
{
  flake.modules = {
    homeManager.profile-gaming =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          steamcmd
        ];
      };
    nixos = {
      profile-gaming =
        { pkgs, ... }:
        {
          imports = with self.modules.nixos; [
            steam-config
          ];
          programs.steam = {
            enable = true;
            extraCompatPackages = with pkgs; [ luxtorpeda ];
            localNetworkGameTransfers.openFirewall = true;
            protontricks.enable = true;
            remotePlay.openFirewall = true;
          };
        };
      steam-config =
        { lib, pkgs, ... }:
        {
          imports = [
            inputs.nixos-steam.nixosModules.default
          ];
          programs.steam.client = {
            enable = true;
            clientBeta = lib.mkDefault "publicbeta";
            defaultCompatTool = "Proton-Wineland Latest";
            environment.STEAM_GAME_LAUNCH_SHELL = "${pkgs.writeShellScript "game-launch-shell" ''
              # steam-runtime-supervisor passes the command line without -c
              if [[ "''${1:-}" != -c ]]; then
                set -- -c "$@"
              fi
              if [[ "$*" =~ (^|[[:space:]])GAME_WRAPPER=([^[:space:]]*) ]]; then
                export GAME_WRAPPER="''${BASH_REMATCH[2]}"
              fi
              exec ${lib.getExe pkgs.local.game-wrapper} /bin/sh "$@"
            ''}";
            friends = {
              categorizeInGameFriendsByGame = false;
              notificationsShowIngame = false;
            };
            gameEnvironment = {
              PIPEWIRE_NODE = "Game";
              PROTON_ENABLE_WAYLAND = true;
              PULSE_SINK = "Game";
            };
            games."993090".beta = "lsfg-vk"; # Lossless Scaling
            runAtStartup = false;
            settings = {
              download_rate_bits_per_s = false;
              download_region = 77; # St. Louis
              download_throttle_while_streaming = false;
              download_while_app_running = true;
              enable_marketing_messages = false;
              enable_overlay = false;
              enable_shader_background_processing = false;
              web_browser_home = "https://www.ecosia.org/";
            };
          };
        };
    };
  };
  flake-file.inputs.nixos-steam = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:parzivale/nixos-steam";
  };
}
