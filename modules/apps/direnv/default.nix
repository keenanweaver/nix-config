{ inputs, home-manager, lib, config, username,  ... }: with lib;
let
  cfg = config.direnv;
in
{
  options = {
    direnv = {
      enable = mkEnableOption "Enable direnv in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      programs = {
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
      };
    };
  };
}
