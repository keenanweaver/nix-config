{
  configurations.nixos.nixos-desktop.module = {
    services.lact = {
      settings = {
        apply_settings_timer = 5;
        auto_switch_profiles = true;
        daemon = {
          admin_group = "wheel";
          disable_clocks_cleanup = false;
          log_level = "info";
        };
        gpus = {
          # Undervolted
          "1002:744C-1EAE:7901-0000:03:00.0" = {
            fan_control_enabled = false;
            performance_level = "auto";
            power_cap = 305.0;
            pwfw_options = {
              zero_rpm = true;
            };
            voltage_offset = -50;
          };
        };
        profiles = {
          # Idea from https://gitlab.freedesktop.org/drm/amd/-/issues/3618#note_2981844
          Gaming = {
            gpus = {
              "1002:744C-1EAE:7901-0000:03:00.0" = {
                fan_control_enabled = false;
                performance_level = "high";
                pwfw_options = {
                  zero_rpm = true;
                };
                # Alternative setup:
                # performance_level = "manual";
                # power_profile_mode_index = 1;
              };
            };
            rule = {
              filter = {
                name = "winedevice.exe";
              };
              type = "process";
            };
          };
        };
        version = 6;
      };
    };
  };
}
