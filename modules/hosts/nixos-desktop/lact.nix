{
  configurations.nixos.nixos-desktop.module =
    { lib, pkgs, ... }:
    {
      services.lact.settings = {
        version = 6;
        apply_settings_timer = 5;
        auto_switch_profiles = true;

        daemon = {
          admin_group = "wheel";
          disable_clocks_cleanup = false;
          log_level = "info";
        };

        gpus."1002:744C-1EAE:7901-0000:03:00.0" = {
          # Undervolted
          fan_control_enabled = false;
          performance_level = "auto";
          pmfw_options.zero_rpm = true;
          power_cap = 305.0;
          voltage_offset = -50;
        };

        profiles = {
          # Idea from https://gitlab.freedesktop.org/drm/amd/-/issues/3618#note_2981844
          "Gaming" = {
            gpus."1002:744C-1EAE:7901-0000:03:00.0" = {
              fan_control_enabled = false;
              performance_level = "high";
              pmfw_options.zero_rpm = true;
            };

            rule = {
              filter.name = "winedevice.exe";
              type = "process";
            };
          };
        };
      };

      # Not sure why I have to do this.
      systemd.services.lactd.serviceConfig.ExecStartPre =
        "${lib.getExe' pkgs.coreutils "rm"} -f /run/lactd.sock";
    };
}
