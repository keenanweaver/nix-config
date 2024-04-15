rule = {
    matches = {
      {
        { "node.name", "equals", "alsa_input.usb-Samson_Technologies_Samson_G-Track_Pro_D0B3381619112B00-00.analog-stereo" },
      },
    },
    apply_properties = {
      ["node.description"] = "Samson G-Track Pro",
    },
  }
  
  table.insert(alsa_monitor.rules, rule)