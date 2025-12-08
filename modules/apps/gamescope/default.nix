{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.gamescope;
in
{
  options = {
    gamescope = {
      enable = lib.mkEnableOption "Enable gamescope in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.gamescope = {
      enable = true;
      package = pkgs.gamescope.overrideAttrs (
        final: prev: {
          # https://github.com/ValveSoftware/gamescope/issues/1622
          NIX_CFLAGS_COMPILE = [ "-fno-fast-math" ];
          patches = prev.patches ++ [
            # Fix Gamescope not closing https://github.com/ValveSoftware/gamescope/pull/1908
            (pkgs.fetchpatch {
              url = "https://github.com/ValveSoftware/gamescope/commit/fa900b0694ffc8b835b91ef47a96ed90ac94823b.patch?full_index=1";
              hash = "sha256-eIHhgonP6YtSqvZx2B98PT1Ej4/o0pdU+4ubdiBgBM4=";
            })
          ];
        }
      );
      capSysNice = false; # 'true' breaks gamescope for Steam https://github.com/NixOS/nixpkgs/issues/292620#issuecomment-2143529075
    };
    home-manager.users.${username} = {
      services.flatpak = {
        packages = [
          "org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/24.08"
          "org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/25.08"
        ];
      };
    };
  };
}
