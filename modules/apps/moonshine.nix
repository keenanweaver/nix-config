{
  flake.modules.nixos.moonshine =
    {
      inputs,
      lib,
      config,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.moonshine.nixosModules.default ];
      chaotic.mesa-git.extraPackages =
        let
          wsiLayer = pkgs.runCommand "moonshine-wsi-layer" { } ''
            install -Dm644 \
              ${config.services.moonshine.package}/share/vulkan/implicit_layer.d/VkLayer_moonshine_wsi.json \
              $out/share/vulkan/implicit_layer.d/VkLayer_moonshine_wsi.json
          '';
        in
        [
          wsiLayer
        ];
      networking.firewall = {
        allowedTCPPorts = [
          # Moonlight
          47984
          47989
          48010
          # MoonDeck Buddy
          59999
        ];
        allowedUDPPorts = [
          47998
          47999
          48000
          48002
          48010
          # Moonlight
          5353
        ];
      };
      services.moonshine = {
        enable = true;
        openFirewall = true;
        settings =
          let
            heroicExe = lib.getExe pkgs.heroic;
            heroicLaunch = pkgs.writeShellApplication {
              name = "moonshine-heroic-launch";
              text = ''
                ${heroicShutdownExe}
                exec ${heroicExe} "$@"
              '';
            };
            heroicLaunchExe = lib.getExe' heroicLaunch "moonshine-heroic-launch";
            heroicShutdown = pkgs.writeShellApplication {
              name = "moonshine-heroic-shutdown";
              runtimeInputs = with pkgs; [
                procps
                coreutils
              ];
              text = ''
                pat='^/nix/store/[^ ]*electron .*/opt/heroic/resources/app.asar'
                pgrep -f "$pat" >/dev/null || exit 0
                pkill -f "$pat" || true
                for _ in {1..30}; do
                  pgrep -f "$pat" >/dev/null || exit 0
                  sleep 1
                done
                echo "heroic still up after 30s, sending SIGKILL" >&2
                pkill -9 -f "$pat" || true
              '';
            };
            heroicShutdownExe = lib.getExe' heroicShutdown "moonshine-heroic-shutdown";
            steamExe = lib.getExe pkgs.steam;
            steamLaunch = pkgs.writeShellApplication {
              name = "moonshine-steam-launch";
              text = ''
                ${steamShutdownExe}
                exec ${steamExe} "$@"
              '';
            };
            steamLaunchExe = lib.getExe' steamLaunch "moonshine-steam-launch";
            steamShutdown = pkgs.writeShellApplication {
              name = "moonshine-steam-shutdown";
              runtimeInputs = with pkgs; [
                procps
                coreutils
              ];
              text = ''
                pgrep -x steam >/dev/null || exit 0

                ${steamExe} -shutdown >/dev/null 2>&1 || true

                for _ in {1..30}; do
                  pgrep -x steam >/dev/null || exit 0
                  sleep 1
                done

                echo "steam still up after 30s, sending SIGTERM" >&2
                pkill -x steam || true
              '';
            };
            steamShutdownExe = lib.getExe' steamShutdown "moonshine-steam-shutdown";
          in
          {
            application = [
              {
                boxart =
                  let
                    icon = pkgs.fetchurl {
                      hash = "sha256-DRHwibH9TqqqSl/LZd19zfWE0qe1RTjb8uSbPMtAbTQ=";
                      url = "https://cdn2.steamgriddb.com/grid/2b1c6cedeaf9571589e3dc9d51ba20e5.png";
                    };
                  in
                  icon;
                command = [
                  heroicLaunchExe
                ];
                title = "Heroic";
              }
              {
                command = [
                  steamLaunchExe
                  "steam://open/bigpicture"
                ];
                title = "Steam";
              }
            ];
            application_scanner = [
              {
                command = [
                  steamLaunchExe
                  "steam://rungameid/{game_id}"
                ];
                library = "$HOME/.local/share/Steam";
                type = "steam";
              }
              {
                command = [
                  heroicLaunchExe
                  "--no-gui"
                  "heroic://launch?appName={app_name}&runner={runner}"
                ];
                type = "heroic";
              }
            ];
            compositor.gpu = config.host.pciDev;
            logFilter = "moonshine=info,moonshine_core::tls=error";
          };
        uid = 1000;
        user = config.my.user;
      };
      users.users.${config.my.user}.extraGroups = [ "moonshine" ];
    };
  flake-file.inputs.moonshine = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:hgaiser/moonshine";
  };
}
