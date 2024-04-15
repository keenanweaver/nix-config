{ inputs, home-manager, lib, config, username, dotfiles, ... }: with lib;
let
  cfg = config.nushell;
in
{
  options = {
    nushell = {
      enable = mkEnableOption "Enable nushell in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      programs.nushell = {
        enable = true;
        configFile.source = "${dotfiles}/.config/nushell/config.nu";
      };
    };
  };
}
