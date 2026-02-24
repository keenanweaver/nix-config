{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.office;
in
{
  options = {
    office = {
      enable = lib.mkEnableOption "Enable office in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    hardware = {
      printers = {
        # https://reddit.com/r/NixOS/comments/1i76ykt/ive_hit_a_wall_with_printer_drivers_brother/m8ikamx/?context=3#m8ikamx
        ensureDefaultPrinter = "Brother_HL-L2460DW";
        ensurePrinters =
          let
            uuid = "e3248000-80ce-11db-8000-94ddf82d6a63";
          in
          [
            {
              name = "Brother_HL-L2460DW";
              description = "Brother HL-L2460DW";
              deviceUri = "dnssd://Brother%20HL-L2460DW._ipp._tcp.local/?uuid=${uuid}";
              model = "drv:///brlaser.drv/brl2405.ppd";
              location = "Office";
            }
          ];
      };
      # Scanning
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
        drivers = with pkgs; [ brlaser ];
        openFirewall = true;
      };
    };
    users.users.${username}.extraGroups = [
      "lp"
      "scanner"
    ];
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        libreoffice-qt
      ];
    };
  };
}
