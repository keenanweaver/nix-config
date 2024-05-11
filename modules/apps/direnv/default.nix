{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.direnv;
in
{
  options = {
    direnv = {
      enable = lib.mkEnableOption "Enable direnv in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs = {
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
      };
    };
  };
}
