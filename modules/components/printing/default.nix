{
  lib,
  config,
  username,
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
    services = {
      # Wireless printing
      # https://reddit.com/r/NixOS/comments/k8yo9e/how_do_you_correcty_setup_a_brother_printer_in/k13rjna/?context=3
      avahi = {
        enable = true;
        nssmdns = true;
        openFirewall = true;
      };
      printing = {
        enable = true;
        openFirewall = true;
      };
    };
    home-manager.users.${username} = { };
  };
}
