{ inputs, home-manager, lib, config, username, ... }: with lib;
let
  cfg = config.cdemu;
in
{
  options = {
    cdemu = {
      enable = mkEnableOption "Enable cdemu in NixOS";
    };
  };
  config = mkIf cfg.enable {
    programs.cdemu = {
      enable = true;
      gui = false;
      image-analyzer = false;
    };
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      /*       home = mkIf (config.networking.hostName == "steamdeck") {
        packages = with pkgs; [ cdemu-client cdemu-daemon ];
      }; */
    };
  };
}
