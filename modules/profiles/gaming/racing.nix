{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfg = config.racing;
in
{
  options = {
    racing = {
      enable = lib.mkEnableOption "Enable racing module in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    boot = {
      extraModulePackages = with config.boot.kernelPackages; [
        universal-pidff
      ];
    };
    environment = {
      etc = {
        "usb_modeswitch.d/046d:c261" = {
          text = ''
            # Logitech G920 Racing Wheel
            DefaultVendor=046d
            DefaultProduct=c261
            MessageEndpoint=01
            ResponseEndpoint=01
            TargetClass=0x03
            MessageContent="0f00010142"
          '';
        };
      };
      systemPackages = with pkgs; [
        #boxflat
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
            name = "70-logitech-g920.rules";
            text = ''
              ATTR{idVendor}=="046d", ATTR{idProduct}=="c261", RUN+="${pkgs.usb-modeswitch}/bin/usb_modeswitch -c '/etc/usb_modeswitch.d/046d:c261'"
            '';
            destination = "/etc/udev/rules.d/70-logitech-g920.rules";
          })
        ];
      };
    };
    home-manager.users.${username} = { };
  };
}
