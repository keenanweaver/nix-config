table.insert (alsa_monitor.rules, {
    matches = {
      {
        -- Match DAC
        { "node.name", "matches", "alsa_output.usb-Schiit_Audio_USB_Modi_Device-00.analog-stereo" },
      },
    },
    apply_properties = {
      ["audio.rate"] = 44100,
    },
  })