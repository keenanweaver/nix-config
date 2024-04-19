{ inputs, home-manager, lib, config, username, pkgs, ... }: with lib;
let
  cfg = config.nix-ld;
in
{
  options = {
    nix-ld = {
      enable = mkEnableOption "Enable nix-ld in NixOS";
    };
  };
  config = mkIf cfg.enable {
    programs.nix-ld = {
      enable = true;
    };
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: { };
  };
}
