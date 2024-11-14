{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.nix-ld;
in
{
  options = {
    nix-ld = {
      enable = lib.mkEnableOption "Enable nix-ld in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.nix-ld = {
      enable = true;
      libraries =
        with pkgs;
        (steam-run.args.multiPkgs pkgs)
        ++ [
          alsa-lib
          fontconfig
          gst_all_1.gstreamer
          gst_all_1.gstreamermm
          gst_all_1.gst-plugins-rs
          gst_all_1.gst-plugins-bad
          gst_all_1.gst-plugins-base
          gst_all_1.gst-plugins-good
          gst_all_1.gst-plugins-ugly
          gst_all_1.gst-libav
          gst_all_1.gst-vaapi
          libGL
          SDL
          SDL2
          SDL2_image
          SDL2_mixer
          SDL2_ttf
          SDL_image
          SDL_mixer
          SDL_ttf
          xorg.libX11
        ];
    };
    home-manager.users.${username} = { };
  };
}
