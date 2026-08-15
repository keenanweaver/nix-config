{
  flake.modules.nixos.office-profile =
    { config, pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ libreoffice-qt ];

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
                description = "Brother HL-L2460DW";
                deviceUri = "dnssd://Brother%20HL-L2460DW._ipp._tcp.local/?uuid=${uuid}";
                location = "Office";
                model = "drv:///brlaser.drv/brl2405.ppd";
                name = "Brother_HL-L2460DW";
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

      services.printing = {
        enable = true;
        drivers = with pkgs; [ brlaser ];
        openFirewall = true;
      };

      users.users.${config.my.user}.extraGroups = [
        "lp"
        "scanner"
      ];
    };
}
