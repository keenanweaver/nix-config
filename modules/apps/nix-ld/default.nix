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
        ++ (heroic.args.multiPkgs pkgs)
        ++ (lutris.args.multiPkgs pkgs)
        ++ [ # https://reddit.com/r/NixOS/comments/1r8igex/help_on_a_game/o6812nx/?context=3#o6812nx
          stdenv.cc.cc
          zlib
          zstd
          bzip2
          xz
          libgcc
          openssl
          curl

          # Graphics / windowing
          libglvnd
          mesa
          vulkan-loader
          sdl3
          sdl2-compat

          libX11
          libXext
          libXrender
          libXfixes
          libXcursor
          libXi
          libXrandr
          libXinerama
          libXdamage
          libXcomposite
          libxcb
          libXau
          libXdmcp

          wayland
          libxkbcommon

          # Audio
          alsa-lib
          pulseaudio

          # Odds and ends often needed
          glib
          gtk3
          nss
          nspr
          dbus
          expat
          libdrm
          udev
        ];
    };
    home-manager.users.${username} = { };
  };
}
