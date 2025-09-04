{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.nix-init;
in
{
  options = {
    nix-init = {
      enable = lib.mkEnableOption "Enable nix-init in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.nix-init = {
        enable = true;
      };
    };
  };
}
