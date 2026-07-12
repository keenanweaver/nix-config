{
  flake.modules.nixos.gaming-profile = { pkgs, inputs, ... }: {
    services.udev = {
      extraHwdb =
        with builtins;
        concatStringsSep "\n" (
          map readFile [
            "${inputs.simracing-hwdb}/90-cammus.hwdb"
            "${inputs.simracing-hwdb}/90-fanatec.hwdb"
            "${inputs.simracing-hwdb}/90-heusinkveld.hwdb"
            "${inputs.simracing-hwdb}/90-leo-bodnar.hwdb"
            "${inputs.simracing-hwdb}/090-logitech.hwdb"
            "${inputs.simracing-hwdb}/90-mmos.hwdb"
            "${inputs.simracing-hwdb}/90-oddor.hwdb"
            "${inputs.simracing-hwdb}/90-shh.hwdb"
            "${inputs.simracing-hwdb}/90-simagic.hwdb"
            "${inputs.simracing-hwdb}/90-simgrade.hwdb"
            "${inputs.simracing-hwdb}/90-simjack.hwdb"
            "${inputs.simracing-hwdb}/90-simlab.hwdb"
            "${inputs.simracing-hwdb}/90-simruito.hwdb"
            "${inputs.simracing-hwdb}/90-simsonn.hwdb"
            "${inputs.simracing-hwdb}/90-simtrecs.hwdb"
            "${inputs.simracing-hwdb}/90-thrustmaster.hwdb"
            "${inputs.simracing-hwdb}/90-vrs.hwdb"
          ]
        );
      packages = with pkgs; [
        game-devices-udev-rules
        (writeTextFile {
          destination = "/etc/udev/rules.d/40-logitech-g920.rules";
          name = "40-logitech-g920.rules";
          text = ''
            ATTR{idVendor}=="046d", ATTR{idProduct}=="c261", RUN+="${lib.getExe usb-modeswitch} -c '/etc/usb_modeswitch.d/046d:c261'"
          '';
        })
        (writeTextFile {
          destination = "/etc/udev/rules.d/70-easysmx.rules";
          name = "70-easysmx.rules";
          text = ''
            # EasySMX X05
            ACTION!="remove", SUBSYSTEM=="usb", ATTR{idProduct}=="0091", ATTR{idVendor}=="2f24", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
          '';
        })
        (writeTextFile {
          destination = "/etc/udev/rules.d/70-gamesir.rules";
          name = "70-gamesir.rules";
          text = ''
            # GameSir Cyclone 2 Wireless Controller; USB
            ## Nintendo Switch
            ACTION!="remove", SUBSYSTEM=="usb", ATTR{idProduct}=="2009", ATTR{idVendor}=="057e", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
            ## D-input/Sony
            ACTION!="remove", SUBSYSTEM=="usb", ATTR{idProduct}=="09cc", ATTR{idVendor}=="054c", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
            ## X-input/XBOX
            ACTION!="remove", SUBSYSTEM=="usb", ATTR{idProduct}=="1053", ATTR{idVendor}=="3537", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
            # GameSir Cyclone 2 Wireless Controller; 2.4GHz
            ## X-input/XBOX
            ACTION!="remove", SUBSYSTEM=="usb", ATTR{idProduct}=="100b", ATTR{idVendor}=="3537", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
            # GameSir Cyclone 2 Wireless Controller; Bluetooth
            ACTION!="remove", SUBSYSTEM=="input", ATTR{idProduct}=="8100", ATTR{idVendor}=="054c", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
          '';
        })
        # 8BitDo Firmware Updater https://gist.github.com/archeYR/d687de5e484ce7b45d6a94415a04f3dc
        (writeTextFile {
          destination = "/etc/udev/rules.d/70-8bitdo.rules";
          name = "70-8bitdo.rules";
          text = ''
            # 8BitDo Arcade Stick; Bluetooth (X-mode)
            ACTION!="remove", SUBSYSTEM=="input", ATTRS{name}=="8BitDo Arcade Stick", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
            # 8BitDo Ultimate 2.4G Wireless  Controller; USB/2.4Ghz
            ## X-mode
            ACTION!="remove", SUBSYSTEM=="usb", ATTR{idProduct}=="3106", ATTR{idVendor}=="2dc8", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
            ## D-mode
            ACTION!="remove", SUBSYSTEM=="usb", ATTR{idProduct}=="3012", ATTR{idVendor}=="2dc8", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
            # 8BitDo Ultimate 2C Wireless Controller; USB/2.4GHz
            ACTION!="remove", SUBSYSTEM=="usb", ATTR{idProduct}=="310a", ATTR{idVendor}=="2dc8", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
            # Firmware Updater
            ACTION!="remove", SUBSYSTEM=="hidraw", ATTRS{idProduct}=="*", ATTRS{idVendor}=="2dc8", TAG+="uaccess"
          '';
        })
        # https://wiki.starcitizen-lug.org/Sticks,-Throttles,-&-Pedals
        (writeTextFile {
          destination = "/etc/udev/rules.d/70-flight-stick.rules";
          name = "70-flight-stick.rules";
          text = ''
            # Thrustmaster
            ACTION!="remove", KERNEL=="hidraw*", ATTRS{idVendor}=="044f", ATTRS{idProduct}=="*", MODE="0660", TAG+="uaccess"
            # Virpil
            ACTION!="remove", KERNEL=="hidraw*", ATTRS{idVendor}=="3344", ATTRS{idProduct}=="*", MODE="0660", TAG+="uaccess"
            ## Virpil Rudder Pedals
            ACTION!="remove", SUBSYSTEM=="input", KERNEL=="event*", \
              ENV{ID_VENDOR_ID}=="3344", ENV{ID_MODEL_ID}=="01f8", \
              RUN+="${lib.getExe' linuxConsoleTools "evdev-joystick"} --e %E{DEVNAME} --d 0"
            # VKB
            ACTION!="remove", KERNEL=="hidraw*", ATTRS{idVendor}=="231d", ATTRS{idProduct}=="*", MODE="0660", TAG+="uaccess"
            ## VKB SEM
            ACTION!="remove", SUBSYSTEM=="input", KERNEL=="event*", \
              ENV{ID_VENDOR_ID}=="231d", ENV{ID_MODEL_ID}=="2204", \
              RUN+="${lib.getExe' linuxConsoleTools "evdev-joystick"} --e %E{DEVNAME} --d 0"
            ## VKB Gunfighter L
            ACTION!="remove", SUBSYSTEM=="input", KERNEL=="event*", \
              ENV{ID_VENDOR_ID}=="231d", ENV{ID_MODEL_ID}=="0127", \
              RUN+="${lib.getExe' linuxConsoleTools "evdev-joystick"} --e %E{DEVNAME} --d 0"
            ## VKB Gunfighter R
            ACTION!="remove", SUBSYSTEM=="input", KERNEL=="event*", \
              ENV{ID_VENDOR_ID}=="231d", ENV{ID_MODEL_ID}=="0126", \
              RUN+="${lib.getExe' linuxConsoleTools "evdev-joystick"} --e %E{DEVNAME} --d 0"
          '';
        })
        # https://wiki.archlinux.org/title/Gamepad#Motion_controls_taking_over_joypad_controls_and/or_causing_unintended_input_with_joypad_controls
        (writeTextFile {
          destination = "/etc/udev/rules.d/51-disable-DS3-and-DS4-motion-controls.rules";
          name = "51-disable-DS3-and-DS4-motion-controls.rules";
          text = ''
            ACTION!="remove", SUBSYSTEM=="input", ATTRS{name}=="*Controller Motion Sensors", RUN+="${lib.getExe' coreutils "rm"} %E{DEVNAME}", ENV{ID_INPUT_JOYSTICK}=""
          '';
        })
        # https://reddit.com/r/linux_gaming/comments/1fu4ggk/can_someone_explain_dualsense_to_me/lpwxv12/?context=3#lpwxv12
        (writeTextFile {
          destination = "/etc/udev/rules.d/51-disable-dualsense-sound-and-vibration.rules";
          name = "51-disable-dualsense-sound-and-vibration.rules";
          text = ''
            ACTION!="remove", KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", MODE="0660", TAG+="uaccess"
            ACTION!="remove", KERNEL=="hidraw*", KERNELS=="*054C:0CE6*", MODE="0660", TAG+="uaccess"
            ACTION!="remove", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", ENV{PULSE_IGNORE}="1", ENV{ACP_IGNORE}="1"
          '';
        })
      ];
    };
  };
}
