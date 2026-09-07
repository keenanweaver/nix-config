{
  flake.modules = {
    homeManager.niri.programs.niri.settings = {
      binds = {
        "Alt+F2".action.spawn-sh = "noctalia msg panel-toggle launcher";
        "Alt+Shift+F4".action.close-window = { };
        "Alt+Tab".action.spawn-sh = "noctalia msg window-switcher";
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+C".action.center-column = { };
        "Mod+Comma".action.spawn-sh = "noctalia msg settings-toggle";
        "Mod+Down".action.focus-window-down = { };
        "Mod+F".action.maximize-column = { };
        "Mod+F12".action.spawn = "wezterm";
        "Mod+Left".action.focus-column-left = { };
        "Mod+Print".action.spawn-sh = "noctalia msg screenshot-window";
        "Mod+Q".action.close-window = { };
        "Mod+R".action.switch-preset-column-width = { };
        "Mod+Return".action.spawn = "wezterm";
        "Mod+Right".action.focus-column-right = { };
        "Mod+S".action.spawn-sh = "noctalia msg panel-toggle control-center";
        "Mod+Shift+1".action.move-column-to-workspace = 1;
        "Mod+Shift+2".action.move-column-to-workspace = 2;
        "Mod+Shift+3".action.move-column-to-workspace = 3;
        "Mod+Shift+Down".action.move-window-down = { };
        "Mod+Shift+E".action.quit.skip-confirmation = true;
        "Mod+Shift+F".action.fullscreen-window = { };
        "Mod+Shift+Left".action.move-column-left = { };
        "Mod+Shift+N".action.spawn-sh = "noctalia msg nightlight-toggle";
        "Mod+Shift+Right".action.move-column-right = { };
        "Mod+Shift+S".action.spawn-sh = "noctalia msg screenshot-region";
        "Mod+Shift+Up".action.move-window-up = { };
        "Mod+Space".action.spawn-sh = "noctalia msg panel-toggle launcher";
        "Mod+Up".action.focus-window-up = { };
        "Mod+V".action.toggle-window-floating = { };
        "Print".action.spawn-sh = "noctalia msg screenshot-screen";
        XF86AudioLowerVolume.action.spawn-sh = "noctalia msg volume-down";
        XF86AudioMute.action.spawn-sh = "noctalia msg volume-mute";
        XF86AudioRaiseVolume.action.spawn-sh = "noctalia msg volume-up";
        XF86MonBrightnessDown.action.spawn-sh = "noctalia msg brightness-down";
        XF86MonBrightnessUp.action.spawn-sh = "noctalia msg brightness-up";
      };
      debug.honor-xdg-activation-with-invalid-serial = true;
      input = {
        keyboard = {
          numlock = false;
          repeat-delay = 250;
          repeat-rate = 25;
          xkb.layout = "us";
        };
        mouse.accel-profile = "flat";
        touchpad = {
          natural-scroll = true;
          tap = true;
        };
      };
      layout = {
        border.enable = false;
        center-focused-column = "on-overflow";
        default-column-width.proportion = 0.5;
        focus-ring = {
          enable = true;
          active.color = "#b4befe";
          inactive.color = "#585b70";
          width = 2;
        };
        gaps = 12;
      };
      overview.backdrop-color = "#11111b";
      prefer-no-csd = true;
      spawn-at-startup = [
        { argv = [ "noctalia" ]; }
      ];
      window-rules = [
        {
          clip-to-geometry = true;
          geometry-corner-radius = {
            bottom-left = 20.0;
            bottom-right = 20.0;
            top-left = 20.0;
            top-right = 20.0;
          };
        }
        {
          default-column-width.fixed = 1080;
          default-window-height.fixed = 920;
          matches = [ { app-id = "dev.noctalia.Noctalia"; } ];
          open-floating = true;
        }
      ];
    };
    nixos.niri =
      { inputs, pkgs, ... }:
      {
        imports = [
          inputs.omniflake.flakes.niri-flake.nixosModules.niri
        ];
        nixpkgs.overlays = [ inputs.omniflake.flakes.niri-flake.overlays.niri ];
        programs.niri = {
          enable = true;
          package = pkgs.niri-unstable;
        };
      };
  };
}
