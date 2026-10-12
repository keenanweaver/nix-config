{ self, inputs, ... }:
{
  flake.modules.nixos.moonshine =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.moonshine.nixosModules.default ];
      assertions = self.lib.mkFactAssertions config [
        "lanInterface"
        "pciDev"
      ];
      chaotic.mesa-git.extraPackages = lib.mkIf config.chaotic.mesa-git.enable [
        (pkgs.runCommand "moonshine-wsi-layer" { } ''
          install -Dm644 \
            ${config.services.moonshine.package}/share/vulkan/implicit_layer.d/VkLayer_moonshine_wsi.json \
            $out/share/vulkan/implicit_layer.d/VkLayer_moonshine_wsi.json
        '')
      ];
      networking.firewall.interfaces =
        let
          inherit (config.services.moonshine) settings;
        in
        lib.genAttrs [ config.host.lanInterface "tailscale0" ] (_: {
          allowedTCPPorts = [
            (settings.webserver.port_https or 47984)
            (settings.webserver.port or 47989)
            (settings.stream.port or 48010)
          ];
          allowedUDPPorts = [
            (settings.stream.video.port or 47998)
            (settings.stream.control.port or 47999)
            (settings.stream.audio.port or 48000)
          ];
        });
      services.moonshine = {
        enable = true;
        settings =
          let
            heroicExe = lib.getExe pkgs.heroic;
            heroicShutdown = mkShutdown rec {
              match = [
                "-f"
                "/heroic/resources/app\\.asar( |$)"
              ];
              name = "heroic";
              stop = ''pkill -u "$uid" ${lib.escapeShellArgs match} || true'';
            };
            mkShutdown =
              {
                match,
                name,
                stop,
              }:
              [
                (lib.getExe (
                  pkgs.writeShellApplication {
                    name = "moonshine-${name}-shutdown";
                    runtimeInputs = with pkgs; [
                      coreutils
                      procps
                    ];
                    text = ''
                      uid=$(id -u)
                      running() {
                        pgrep -u "$uid" ${lib.escapeShellArgs match} >/dev/null
                      }

                      running || exit 0

                      ${stop}

                      for _ in {1..30}; do
                        running || exit 0
                        sleep 1
                      done

                      echo "${name} still up after 30s, sending SIGKILL" >&2
                      pkill -KILL -u "$uid" ${lib.escapeShellArgs match} || true

                      for _ in {1..5}; do
                        running || exit 0
                        sleep 1
                      done

                      echo "${name} did not exit" >&2
                      exit 1
                    '';
                  }
                ))
              ];
            steamExe = lib.getExe config.programs.steam.package;
            steamShutdown = mkShutdown {
              match = [
                "-x"
                "steam"
              ];
              name = "steam";
              stop = "${steamExe} -shutdown >/dev/null 2>&1 || true";
            };
          in
          {
            application = [
              {
                boxart = pkgs.fetchurl {
                  hash = "sha256-DRHwibH9TqqqSl/LZd19zfWE0qe1RTjb8uSbPMtAbTQ=";
                  url = "https://cdn2.steamgriddb.com/grid/2b1c6cedeaf9571589e3dc9d51ba20e5.png";
                };
                command = [ heroicExe ];
                pre_command = [ heroicShutdown ];
                title = "Heroic";
              }
              {
                command = [
                  steamExe
                  "steam://open/bigpicture"
                ];
                pre_command = [ steamShutdown ];
                title = "Steam";
              }
            ];
            application_scanner = [
              {
                command = [
                  steamExe
                  "steam://rungameid/{game_id}"
                ];
                library = "$HOME/.local/share/Steam";
                pre_command = [ steamShutdown ];
                type = "steam";
              }
              {
                command = [
                  heroicExe
                  "--no-gui"
                  "heroic://launch?appName={app_name}&runner={runner}"
                ];
                pre_command = [ heroicShutdown ];
                type = "heroic";
              }
            ];
            compositor.gpu = config.host.pciDev;
          };
        user = config.my.user;
      };
      users.users.${config.my.user}.extraGroups = [ "moonshine" ];
    };
  flake-file.inputs.moonshine = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:hgaiser/moonshine";
  };
}
