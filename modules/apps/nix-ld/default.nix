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
        ++ [
          alsa-lib
          dbus
          glibc
          gtk3
          icu
          libcap
          libxcrypt
          libGL
          libdrm
          libudev0-shim
          libva
          mesa
          networkmanager
          pkg-config
          xorg.libX11
          xorg.libXext
          udev
          vulkan-loader
        ];
    };
    home-manager.users.${username} = { };
  };
}
