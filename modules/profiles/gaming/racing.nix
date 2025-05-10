{
  pkgs,
  username,
  ...
}:
{
  environment = {
    etc = {
      logitech-g920 = {
        text = ''
          DefaultVendor=046d
          DefaultProduct=c261
          MessageEndpoint=01
          ResponseEndpoint=01
          TargetClass=0x03
          MessageContent="0f00010142"
        '';
        target = "usb_modeswitch.d/046d:c261";
      };
    };
    systemPackages = with pkgs; [
      oversteer
      usb-modeswitch
      usb-modeswitch-data
    ];
  };
  hardware = {
    new-lg4ff.enable = true;
  };
  services = {
    udev = {
      packages = with pkgs; [
        (writeTextFile {
          name = "40-logitech-g920.rules";
          text = ''
            ATTR{idVendor}=="046d", ATTR{idProduct}=="c261", RUN+="${pkgs.usb-modeswitch}/bin/usb_modeswitch -c '/etc/usb_modeswitch.d/046d:c261'"
          '';
          destination = "/etc/udev/rules.d/40-logitech-g920.rules";
        })
      ];
    };
  };
  home-manager.users.${username} = { };
}
