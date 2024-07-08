{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.wezterm;
in
{
  options = {
    wezterm = {
      enable = lib.mkEnableOption "Enable wezterm in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.wezterm = {
        enable = true;
        extraConfig = ''
          local wezterm = require 'wezterm'
          local mux = wezterm.mux
          local act = wezterm.action
          local config = {}

          if wezterm.config_builder then
              config = wezterm.config_builder()
          end

          wezterm.on('gui-startup', function(cmd)
            local args = {}
            if cmd then
              args = cmd.args
            end
            -- Main
            local tab, main_pane, window = mux.spawn_window { workspace = 'Main', args = args, }
            local bash_pane = main_pane:split { direction = 'Bottom', size = 0.015 }
            bash_pane:send_text 'bash\nclear\n'
            tab:set_title 'main'
            window:set_title ' main '
            -- btop tab
            local btop_tab, btop_pane, _ = window:spawn_tab { args = { 'btop' } }
            -- local dua_pane = btop_pane:split { direction = 'Top' }
            -- local nnn_pane = dua_pane:split { direction = 'Right' }
            -- dua_pane:send_text 'dua interactive\n'
            -- nnn_pane:send_text 'nnn -dHix\n'
            btop_tab:set_title ' btop '
            -- nvtop tab
            local nvtop_tab, nvtop_pane, _ = window:spawn_tab { args = { 'nvtop' } }
            nvtop_tab:set_title ' nvtop '
            -- kmon tab
            local kmon_tab, kmon_pane, _ = window:spawn_tab { args = { 'kmon' } }
            kmon_tab:set_title ' kmon '
            -- yazi tab
            local yazi_tab, yazi_pane, _ = window:spawn_tab { args = { 'yazi' } }
            yazi_tab:set_title ' yazi '
            -- SSHS tab
            local sshs_tab, sshs_pane, _ = window:spawn_tab { }
            sshs_pane:send_text 'sshs\n'
            sshs_tab:set_title ' sshs '
            -- Distrobox tab
            local db_tab, db_bag_pane, _ = window:spawn_tab { }
            local db_bae_pane = db_bag_pane:split { direction = 'Bottom' }
            db_bag_pane:send_text 'distrobox enter bazzite-arch-gaming\nclear\n'
            db_bae_pane:send_text 'distrobox enter bazzite-arch-exodos\nclear\n'
            db_tab:set_title ' distrobox '
            -- fastfetch tab
            local ff_tab, ff_pane, _ = window:spawn_tab { }
            local neo_pane = ff_pane:split { direction = 'Bottom', size = 0.2 }
            ff_pane:send_text 'fastfetch -c neofetch\n'
            neo_pane:send_text 'neo -D -b 1\n'
            ff_tab:set_title ' fetch '
            -- Set active panes
            db_bag_pane:activate()
            main_pane:activate()
            -- nnn_pane:activate()
            mux.set_active_workspace 'Main'
            window:gui_window():maximize()
          end)

          config.color_scheme = 'Catppuccin Mocha'
          config.default_prog = { "zsh" }
          config.font_size = 14
          config.font = wezterm.font_with_fallback { { family = 'JetBrainsMono Nerd Font', weight = "Medium" }, { family = 'BlexMono Nerd Font', weight = "Medium" }, }
          config.unzoom_on_switch_pane = true
          config.check_for_updates = false
          config.line_height = 1.0
          config.disable_default_key_bindings = true
          config.keys = {
              { mods = 'CTRL|SHIFT',     key = 't',          action = act.ShowTabNavigator },
              { mods = 'CTRL|SHIFT',     key = 'q',          action = act.QuitApplication },
              { mods = "ALT",            key = [[\]],        action = act { SplitHorizontal = { domain = "CurrentPaneDomain" } } },
              { mods = "CTRL",           key = [[\]],        action = act { SplitVertical = { domain = "CurrentPaneDomain" } } },
              { mods = "CTRL",           key = "t",          action = act { SpawnTab = "CurrentPaneDomain" } },
              { mods = "CTRL",           key = "w",          action = act { CloseCurrentPane = { confirm = false } } },
              { mods = "CTRL|SHIFT",     key = "w",          action = act { CloseCurrentTab = { confirm = false } } },
              { mods = "ALT",            key = "]",          action = act { ActivateTabRelative = 1 } },
              { mods = "ALT",            key = "[",          action = act { ActivateTabRelative = -1 } },
              { mods = 'ALT',            key = 'LeftArrow',  action = act.ActivatePaneDirection 'Left', },
              { mods = 'ALT',            key = 'RightArrow', action = act.ActivatePaneDirection 'Right', },
              { mods = 'ALT',            key = 'DownArrow',  action = act.ActivatePaneDirection 'Down', },
              { mods = 'ALT',            key = 'UpArrow',    action = act.ActivatePaneDirection 'Up', },
              { mods = 'CTRL|ALT',       key = 'LeftArrow',  action = act.AdjustPaneSize { 'Left', 1 } },
              { mods = 'CTRL|ALT',       key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 1 } },
              { mods = 'CTRL|ALT',       key = 'DownArrow',  action = act.AdjustPaneSize { 'Down', 1 } },
              { mods = 'CTRL|ALT',       key = 'UpArrow',    action = act.AdjustPaneSize { 'Up', 1 } },
              { mods = "CTRL|SHIFT",     key = "c",          action = act { CopyTo = "ClipboardAndPrimarySelection" } },
              { mods = "CTRL|SHIFT",     key = "v",          action = act { PasteFrom = "Clipboard" } },
              { mods = "SHIFT",          key = "Insert",     action = act { PasteFrom = "Clipboard" } },
              { mods = "CTRL",           key = ")",          action = act.ResetFontSize },
              { mods = "CTRL|SHIFT",     key = ")",          action = act.ResetFontSize },
              { mods = 'CTRL',           key = '0',          action = act.ResetFontSize },
              { mods = 'SHIFT|CTRL',     key = '0',          action = act.ResetFontSize },
              { mods = 'SUPER',          key = '0',          action = act.ResetFontSize },
              { mods = "CTRL",           key = "+",          action = act.IncreaseFontSize },
              { mods = "CTRL|SHIFT",     key = "+",          action = act.IncreaseFontSize },
              { mods = 'CTRL',           key = '=',          action = act.IncreaseFontSize },
              { mods = 'SHIFT|CTRL',     key = '=',          action = act.IncreaseFontSize },
              { mods = 'SUPER',          key = '=',          action = act.IncreaseFontSize },
              { mods = "CTRL",           key = "-",          action = act.DecreaseFontSize },
              { mods = "CTRL|SHIFT",     key = "-",          action = act.DecreaseFontSize },
              { mods = 'CTRL',           key = '_',          action = act.DecreaseFontSize },
              { mods = 'SHIFT|CTRL',     key = '_',          action = act.DecreaseFontSize },
              { mods = "ALT",            key = "1",          action = act { ActivateTab = 0 } },
              { mods = "ALT",            key = "2",          action = act { ActivateTab = 1 } },
              { mods = "ALT",            key = "3",          action = act { ActivateTab = 2 } },
              { mods = "ALT",            key = "4",          action = act { ActivateTab = 3 } },
              { mods = "ALT",            key = "5",          action = act { ActivateTab = 4 } },
              { mods = "ALT",            key = "6",          action = act { ActivateTab = 5 } },
              { mods = "ALT",            key = "7",          action = act { ActivateTab = 6 } },
              { mods = "ALT",            key = "8",          action = act { ActivateTab = 7 } },
              { mods = "ALT",            key = "9",          action = act { ActivateTab = 8 } },
            }
            config.audible_bell = "Disabled"
            config.exit_behavior = "Close"
            config.window_close_confirmation = "NeverPrompt"
            config.scrollback_lines = 50000
            config.tab_max_width = 9999
            config.window_padding = { left = '10pt', right = '10pt', top = '10pt', bottom = '10pt' }
            config.window_background_opacity = 0.7
            config.enable_tab_bar = true
            config.use_fancy_tab_bar = false
            config.hide_tab_bar_if_only_one_tab = true
            config.show_tab_index_in_tab_bar = false

          return config
        '';
      };
    };
  };
}
