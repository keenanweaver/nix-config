{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.printing;
in
{
  options = {
    printing = {
      enable = lib.mkEnableOption "Enable printing in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    # Scanning
    hardware = {
      sane = {
        enable = true;
        brscan5.enable = true;
        dsseries.enable = true;
      };
    };
    services = {
      # Wireless printing
      # https://reddit.com/r/NixOS/comments/k8yo9e/how_do_you_correcty_setup_a_brother_printer_in/k13rjna/?context=3
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
      printing = {
        enable = true;
        openFirewall = true;
      };
    };
    users.users.${username}.extraGroups = [
      "lp"
      "scanner"
    ];
    home-manager.users.${username} = {
      home.packages = with pkgs; with pkgs.kdePackages; [ skanlite ];
    };
  };
}
