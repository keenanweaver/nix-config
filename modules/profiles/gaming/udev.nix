{ pkgs, ... }:
with pkgs;
[
  game-devices-udev-rules
  (writeTextFile {
    name = "40-logitech-g920.rules";
    destination = "/etc/udev/rules.d/40-logitech-g920.rules";
    text = ''
      ATTR{idVendor}=="046d", ATTR{idProduct}=="c261", RUN+="${usb-modeswitch}/bin/usb_modeswitch -c '/etc/usb_modeswitch.d/046d:c261'"
    '';
  })
  # https://wiki.cachyos.org/configuration/general_system_tweaks/#how-to-enable-adios
  (writeTextFile {
    name = "60-ioschedulers.rules";
    destination = "/etc/udev/rules.d/60-ioschedulers.rules";
    text = ''
      # HDD
      ACTION!="remove", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
      # SSD
      ACTION!="remove", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="adios"
      # NVMe SSD
      ACTION!="remove", KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="adios"
    '';
  })
  # https://github.com/CachyOS/CachyOS-Settings/blob/master/usr/lib/udev/rules.d/69-hdparm.rules
  (writeTextFile {
    name = "69-hdparm.rules";
    destination = "/etc/udev/rules.d/69-hdparm.rules";
    text = ''
      ACTION!="remove", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", RUN+="${hdparm}/bin/hdparm -B 254 -S 0 /dev/%k"
    '';
  })
  (writeTextFile {
    name = "70-easysmx.rules";
    destination = "/etc/udev/rules.d/70-easysmx.rules";
    text = ''
      # EasySMX X05
      ACTION!="remove", SUBSYSTEM=="usb", ATTR{idProduct}=="0091", ATTR{idVendor}=="2f24", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
    '';
  })
  (writeTextFile {
    name = "70-gamesir.rules";
    destination = "/etc/udev/rules.d/70-gamesir.rules";
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
    name = "70-8bitdo.rules";
    destination = "/etc/udev/rules.d/70-8bitdo.rules";
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
    name = "70-flight-stick.rules";
    destination = "/etc/udev/rules.d/70-flight-stick.rules";
    text = ''
      # Thrustmaster
      ACTION!="remove", KERNEL=="hidraw*", ATTRS{idVendor}=="044f", ATTRS{idProduct}=="*", MODE="0660", TAG+="uaccess"
      # Virpil
      ACTION!="remove", KERNEL=="hidraw*", ATTRS{idVendor}=="3344", ATTRS{idProduct}=="*", MODE="0660", TAG+="uaccess"
      ## Virpil Rudder Pedals
      ACTION!="remove", SUBSYSTEM=="input", KERNEL=="event*", \
        ENV{ID_VENDOR_ID}=="3344", ENV{ID_MODEL_ID}=="01f8", \
        RUN+="${linuxConsoleTools}/bin/evdev-joystick --e %E{DEVNAME} --d 0"
      # VKB
      ACTION!="remove", KERNEL=="hidraw*", ATTRS{idVendor}=="231d", ATTRS{idProduct}=="*", MODE="0660", TAG+="uaccess"
      ## VKB SEM
      ACTION!="remove", SUBSYSTEM=="input", KERNEL=="event*", \
        ENV{ID_VENDOR_ID}=="231d", ENV{ID_MODEL_ID}=="2204", \
        RUN+="${linuxConsoleTools}/bin/evdev-joystick --e %E{DEVNAME} --d 0"
      ## VKB Gunfighter L
      ACTION!="remove", SUBSYSTEM=="input", KERNEL=="event*", \
        ENV{ID_VENDOR_ID}=="231d", ENV{ID_MODEL_ID}=="0127", \
        RUN+="${linuxConsoleTools}/bin/evdev-joystick --e %E{DEVNAME} --d 0"
      ## VKB Gunfighter R
      ACTION!="remove", SUBSYSTEM=="input", KERNEL=="event*", \
        ENV{ID_VENDOR_ID}=="231d", ENV{ID_MODEL_ID}=="0126", \
        RUN+="${linuxConsoleTools}/bin/evdev-joystick --e %E{DEVNAME} --d 0"
    '';
  })
  (writeTextFile {
    name = "ntsync-udev-rules";
    destination = "/etc/udev/rules.d/70-ntsync.rules";
    text = ''
      KERNEL=="ntsync", MODE="0660", TAG+="uaccess"
    '';
  })
  # https://wiki.archlinux.org/title/Gamepad#Motion_controls_taking_over_joypad_controls_and/or_causing_unintended_input_with_joypad_controls
  (writeTextFile {
    name = "51-disable-DS3-and-DS4-motion-controls.rules";
    destination = "/etc/udev/rules.d/51-disable-DS3-and-DS4-motion-controls.rules";
    text = ''
      ACTION!="remove", SUBSYSTEM=="input", ATTRS{name}=="*Controller Motion Sensors", RUN+="${coreutils}/bin/rm %E{DEVNAME}", ENV{ID_INPUT_JOYSTICK}=""
    '';
  })
  # https://reddit.com/r/linux_gaming/comments/1fu4ggk/can_someone_explain_dualsense_to_me/lpwxv12/?context=3#lpwxv12
  (writeTextFile {
    name = "51-disable-dualsense-sound-and-vibration.rules";
    destination = "/etc/udev/rules.d/51-disable-dualsense-sound-and-vibration.rules";
    text = ''
      ACTION!="remove", KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", MODE="0660", TAG+="uaccess"
      ACTION!="remove", KERNEL=="hidraw*", KERNELS=="*054C:0CE6*", MODE="0660", TAG+="uaccess"
      ACTION!="remove", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", ENV{PULSE_IGNORE}="1", ENV{ACP_IGNORE}="1"
    '';
  })
]
