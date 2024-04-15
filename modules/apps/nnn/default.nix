{ inputs, home-manager, lib, config, username,  ... }: with lib;
let
  cfg = config.nnn;
in
{
  options = {
    nnn = {
      enable = mkEnableOption "Enable nnn in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      programs.nnn = with pkgs; {
        enable = true;
        package = nnn.override ({ withNerdIcons = true; });
      };
    };
  };
}
