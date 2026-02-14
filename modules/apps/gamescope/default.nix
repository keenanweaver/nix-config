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
      enableScopeBuddy = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    programs.gamescope = {
      enable = true;
      package = pkgs.gamescope.overrideAttrs (
        final: prev: {
          # https://github.com/ValveSoftware/gamescope/issues/1622
          NIX_CFLAGS_COMPILE = [ "-fno-fast-math" ];
          patches =
            with pkgs;
            prev.patches
            ++ [
              # Fix Gamescope not closing
              (fetchpatch {
                url = "https://github.com/ValveSoftware/gamescope/pull/1908.patch";
                hash = "sha256-eIHhgonP6YtSqvZx2B98PT1Ej4/o0pdU+4ubdiBgBM4=";
              })
            ];
        }
      );
      capSysNice = false; # 'true' breaks gamescope for Steam https://github.com/NixOS/nixpkgs/issues/292620#issuecomment-2143529075
    };
    home-manager.users.${username} =
      { inputs, config, ... }:
      {
        home.file = {
          scb-config = lib.mkIf cfg.enableScopeBuddy {
            enable = true;
            text = ''
              SCB_AUTO_RES=1
              SCB_AUTO_HDR=1
              SCB_AUTO_VRR=1
              SCB_GAMESCOPE_ARGS="--mangoapp -f --force-grab-cursor --hdr-enabled"
            '';
            target = "${config.xdg.configHome}/scopebuddy/scb.conf";
          };
        };
        home.packages =
          with pkgs;
          lib.mkIf cfg.enableScopeBuddy [
            inputs.just-one-more-repo.packages.${stdenv.hostPlatform.system}.scopebuddy
          ];
        services.flatpak = {
          packages = [
            "org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/24.08"
            "org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/25.08"
          ];
        };
      };
  };
}
