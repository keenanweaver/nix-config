{
  flake.modules.nixos.gaming-profile = {
    preservation.preserveAt."/persist".directories = [
      "/etc/lact"
    ];
    services.lact = {
      enable = true;
      settings = {
        apply_settings_timer = 5;
        auto_switch_profiles = true;
        daemon = {
          admin_group = "wheel";
          disable_clocks_cleanup = false;
          log_level = "info";
        };
        version = 5;
      };
    };
  };
}
