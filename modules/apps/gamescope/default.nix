{
  lib,
  config,
  username,
  pkgs,
  inputs,
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
      package = inputs.chaotic.packages.${pkgs.system}.gamescope_git.overrideAttrs (
        final: prev: {
          # https://github.com/ValveSoftware/gamescope/issues/1622
          NIX_CFLAGS_COMPILE = [ "-fno-fast-math" ];
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
