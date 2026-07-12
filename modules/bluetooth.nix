{
  flake.modules.nixos.desktop-profile = {
    hardware.bluetooth = {
      enable = true;
      settings = {
        General = {
          AutoEnable = false;
          ControllerMode = "bredr";
          Experimental = "true";
        }; # https://reddit.com/r/NixOS/comments/1aoteqb/keychron_k1_pro_bluetooth_nixos_wkde_install/kq49q9r/?context=3
      };
    };

    preservation.preserveAt."/persist".directories = [
      "/var/lib/bluetooth"
    ];
  };
}
