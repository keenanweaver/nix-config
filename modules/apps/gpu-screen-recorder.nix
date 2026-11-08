{ inputs, ... }:
{
  flake.modules.nixos.profile-gaming =
    { pkgs, ... }:
    let
      gsrPkgs = import inputs.nixpkgs-gsr {
        inherit (pkgs) config;
        inherit (pkgs.stdenv.hostPlatform) system;
      };
    in
    {
      imports = [ "${inputs.nixpkgs-gsr}/nixos/modules/programs/gpu-screen-recorder.nix" ];
      # Until https://github.com/NixOS/nixpkgs/pull/580322 reaches nixos-unstable
      disabledModules = [ "programs/gpu-screen-recorder.nix" ];
      programs.gpu-screen-recorder = {
        enable = true;
        package = gsrPkgs.gpu-screen-recorder;
        gtk.enable = true;
        ui = {
          enable = true;
          package = gsrPkgs.gpu-screen-recorder-ui;
          notifPackage = gsrPkgs.gpu-screen-recorder-notification;
        };
      };
    };
  flake-file.inputs.nixpkgs-gsr = {
    flake = false;
    url = "github:NixOS/nixpkgs/74b89c527c44b19c7396d7686412dab882c7aee7";
  };
}
