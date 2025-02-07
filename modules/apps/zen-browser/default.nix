{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.zen-browser;
in
{
  options = {
    zen-browser = {
      enable = lib.mkEnableOption "Enable zen in NixOS";
      enableFlatpak = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      enableNative = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.flatpak = lib.mkIf cfg.enableFlatpak {
      packages = [
        "app.zen_browser.zen"
      ];
      overrides = {
        "app.zen_browser.zen" = {
          Environment = {
            MOZ_ENABLE_WAYLAND = "1";
          };
        };
      };
    };
    home-manager.users.${username} = {
      home.file = {
        userjs-flatpak = {
          enable = cfg.enableFlatpak;
          text = ''
            /* KDE integration */
            user_pref("widget.use-xdg-desktop-portal.mime-handler", 1);
            user_pref("widget.use-xdg-desktop-portal.file-picker", 1);
            /* Hardware acceleration */
            user_pref("gfx.webrender.all", true);
            user_pref("media.ffmpeg.vaapi.enable", true);
            /* Font */
            user_pref("gfx.font_rendering.cleartype_params.rendering_mode", 5);
            /* Disable autofill & password */
            user_pref("extensions.formautofill.addresses.enabled", false);
            user_pref("extensions.formautofill.creditCards.enabled", false);
            user_pref("signon.rememberSignons", false);
            /* Autoplay enable */
            user_pref("media.autoplay.default", 1); /* Disable autoplay with sound */
            /* Enable DRM content */
            user_pref("media.eme.enabled", true);
            user_pref("browser.eme.ui.enabled", true);
            /* Scroll settings */
            user_pref("general.autoScroll", true);
            user_pref("general.smoothScroll", true);
            user_pref("general.smoothScroll.currentVelocityWeighting", 0.15);
            user_pref("general.smoothScroll.mouseWheel.durationMinMS", 80);
            user_pref("general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS", 12);
            user_pref("general.smoothScroll.msdPhysics.enabled", true);
            user_pref("general.smoothScroll.msdPhysics.motionBeginSpringConstant", 600);
            user_pref("general.smoothScroll.msdPhysics.regularSpringConstant", 650);
            user_pref("general.smoothScroll.msdPhysics.slowdownMinDeltaMS", 25);
            user_pref("general.smoothScroll.msdPhysics.slowdownSpringConstant", 250);
            user_pref("general.smoothScroll.stopDecelerationWeighting", 0.6);
            user_pref("mousewheel.min_line_scroll_amount", 10);
            /* Autofill */
            user_pref("browser.formfill.enable", false);
            user_pref("extensions.formautofill.addresses.enabled", false);
            user_pref("extensions.formautofill.creditCards.enabled", false);
            user_pref("signon.management.page.breach-alerts.enabled", false);
            user_pref("signon.rememberSignons", false);
            user_pref("signon.autofillForms", false);
            /* DRM content */
            user_pref("browser.eme.ui.enabled", true);
            user_pref("media.eme.enabled", true);
          '';
          target = ".var/app/app.zen_browser.zen/.zen/${username}/user.js";
        };
      };
    };
  };
}
