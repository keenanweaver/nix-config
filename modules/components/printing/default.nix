{ inputs, home-manager, lib, config, pkgs, username, ... }: with lib;
let
  cfg = config.printing;
in
{
  options = {
    printing = {
      enable = mkEnableOption "Enable printing in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    services = {
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
        publish = {
          enable = true;
          userServices = true;
        };
      };
      printing = {
        enable = true;
        drivers = with pkgs; [ hplipWithPlugin ];
        openFirewall = true;
      };
    };
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: { };
  };
}
