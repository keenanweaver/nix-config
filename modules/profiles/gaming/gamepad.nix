{
  config,
  pkgs,
  username,
  ...
}:
let
  p = with pkgs; [
    joystickwake
    sc-controller
  ];
in
{
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [
      gcadapter-oc-kmod
    ];
    kernelModules = [
      "gcadapter_oc"
    ];
  };

  hardware = {
    uinput.enable = true;
    xpadneo.enable = true;
  };

  services = {
    input-remapper = {
      enable = true;
    };
    udev = {
      packages = with pkgs; [
        game-devices-udev-rules
        (writeTextFile {
          name = "70-easysmx.rules";
          text = ''
            # EasySMX X05
            SUBSYSTEM=="usb", ATTR{idProduct}=="0091", ATTR{idVendor}=="2f24", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
          '';
          destination = "/etc/udev/rules.d/70-easysmx.rules";
        })
        (writeTextFile {
          name = "70-gamesir.rules";
          text = ''
            # GameSir Cyclone 2 Wireless Controller
            SUBSYSTEM=="usb", ATTR{idProduct}=="0575", ATTR{idVendor}=="3537", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
          '';
          destination = "/etc/udev/rules.d/70-gamesir.rules";
        })
        (writeTextFile {
          name = "70-8bitdo.rules";
          text = ''
            # 8BitDo Arcade Stick; Bluetooth (X-mode)
            SUBSYSTEM=="input", ATTRS{name}=="8BitDo Arcade Stick", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
            # 8BitDo Ultimate 2.4G Wireless  Controller; USB/2.4Ghz
            # X-mode
            SUBSYSTEM=="usb", ATTR{idProduct}=="3106", ATTR{idVendor}=="2dc8", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
            # D-mode
            SUBSYSTEM=="usb", ATTR{idProduct}=="3012", ATTR{idVendor}=="2dc8", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
            # 8BitDo Ultimate 2C Wireless Controller; USB/2.4GHz
            SUBSYSTEM=="usb", ATTR{idProduct}=="310a", ATTR{idVendor}=="2dc8", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
          '';
          destination = "/etc/udev/rules.d/70-8bitdo.rules";
        })
        # https://wiki.archlinux.org/title/Gamepad#Motion_controls_taking_over_joypad_controls_and/or_causing_unintended_input_with_joypad_controls
        (writeTextFile {
          name = "51-disable-DS3-and-DS4-motion-controls.rules";
          text = ''
            SUBSYSTEM=="input", ATTRS{name}=="*Controller Motion Sensors", RUN+="${pkgs.coreutils}/bin/rm %E{DEVNAME}", ENV{ID_INPUT_JOYSTICK}=""
          '';
          destination = "/etc/udev/rules.d/51-disable-DS3-and-DS4-motion-controls.rules";
        })
        # https://reddit.com/r/linux_gaming/comments/1fu4ggk/can_someone_explain_dualsense_to_me/lpwxv12/?context=3#lpwxv12
        (writeTextFile {
          name = "51-disable-dualsense-sound-and-vibration.rules";
          text = ''
            KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", MODE="0660", TAG+="uaccess"
            KERNEL=="hidraw*", KERNELS=="*054C:0CE6*", MODE="0660", TAG+="uaccess"
            ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", ENV{PULSE_IGNORE}="1", ENV{ACP_IGNORE}="1"
          '';
          destination = "/etc/udev/rules.d/51-disable-dualsense-sound-and-vibration.rules";
        })
      ];
    };
  };
  home-manager.users.${username} = {
    home.packages = [ p ];
  };
}
