{
  flake.modules = {
    homeManager.gaming-profile =
      {
        config,
        pkgs,
        inputs,
        ...
      }:
      {
        home = {
          file = {
            scb-config = {
              enable = true;
              target = "${config.xdg.configHome}/scopebuddy/scb.conf";
              text = ''
                SCB_AUTO_RES=1
                SCB_AUTO_HDR=1
                SCB_AUTO_VRR=1
                SCB_GAMESCOPE_ARGS="--mangoapp -f --force-grab-cursor --hdr-enabled"
              '';
            };
          };
          packages = [
            inputs.just-one-more-repo.packages.${pkgs.stdenv.hostPlatform.system}.scopebuddy
          ];
        };
        services.flatpak = {
          packages = [
            "org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/24.08"
            "org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/25.08"
          ];
        };
      };
    nixos.gaming-profile =
      {
        pkgs,
        inputs,
        ...
      }:
      {
        nixpkgs.overlays = [
          (_final: _prev: {
            gamescope = inputs.chaotic.legacyPackages.x86_64-linux.gamescope_git;
          })
        ];
        programs.gamescope = {
          enable = true;
          package = pkgs.gamescope.overrideAttrs (
            _final: prev: {
              # https://github.com/ValveSoftware/gamescope/issues/1622
              NIX_CFLAGS_COMPILE = [ "-fno-fast-math" ];
              patches =
                with pkgs;
                prev.patches
                ++ [
                  # Fix Gamescope not closing
                  (fetchpatch {
                    hash = "sha256-eIHhgonP6YtSqvZx2B98PT1Ej4/o0pdU+4ubdiBgBM4=";
                    url = "https://github.com/ValveSoftware/gamescope/pull/1908.patch";
                  })
                ];
            }
          );
          capSysNice = false; # 'true' breaks gamescope for Steam https://github.com/NixOS/nixpkgs/issues/292620#issuecomment-2143529075
        };
      };
  };
}
