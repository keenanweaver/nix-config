{
  lib,
  config,
  username,
  vars,
  inputs,
  ...
}:
let
  cfg = config.nixConfig;
in
{
  options = {
    nixConfig = {
      enable = lib.mkEnableOption "Enable nix in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    nix = {
      settings = {
        builders-use-substitutes = true;
        experimental-features = [
          "flakes"
          "nix-command"
        ];
        extra-substituters = [
          "https://nix-community.cachix.org"
        ];
        extra-trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        log-lines = lib.mkDefault 50;
        trusted-users = [
          "${username}"
          "@wheel"
        ];
        use-xdg-base-directories = false;
        warn-dirty = false;
      };
    };
    nixpkgs = {
      config = {
        allowBroken = false;
        allowUnfree = true;
      };
      overlays = [
        (import ../../../packages/overlay.nix { inherit inputs; })
      ];
    };
    system = {
      autoUpgrade = {
        enable = if vars.desktop then false else true;
        allowReboot = if vars.desktop then false else true;
        dates = "04:00:00";
        rebootWindow = {
          lower = "04:00";
          upper = "06:00";
        };
      };
    };

    home-manager.users.${username} = {
      nixpkgs = {
        config = {
          allowBroken = false;
          allowUnfree = true;
        };
        overlays = [
          (import ../../../packages/overlay.nix { inherit inputs; })
        ];
      };
    };
  };
}
