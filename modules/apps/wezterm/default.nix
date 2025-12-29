{
  lib,
  config,
  username,
  pkgs,
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
    home-manager.users.${username} =
      { config, ... }:
      {
        programs.wezterm = {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
          extraConfig = ''
            local wezterm = require 'wezterm'
            local config = wezterm.config_builder()
            local act = wezterm.action

            -- Appearance
            config.font_size = ${toString config.programs.plasma.fonts.fixedWidth.pointSize}
            config.window_background_opacity = 0.7
            config.color_scheme = "Catppuccin Mocha"

            -- Font configuration
            config.font = wezterm.font_with_fallback {
              '${config.programs.plasma.fonts.fixedWidth.family}',
            }
            config.font_rules = {
              {
                intensity = 'Bold',
                italic = true,
                font = wezterm.font {
                  family = '${config.programs.plasma.fonts.fixedWidth.family}',
                  weight = 'Bold',
                  style = 'Italic',
                },
              },
            }
            config.line_height = 1.0
            config.freetype_load_target = 'Normal'
            config.freetype_render_target = 'HorizontalLcd'

            -- Default shell
            config.default_prog = { 'zsh' }

            -- Cursor
            config.default_cursor_style = 'SteadyBlock'
            config.cursor_blink_rate = 800
            config.cursor_blink_ease_in = 'Constant'
            config.cursor_blink_ease_out = 'Constant'

            -- Scrollback
            config.scrollback_lines = 10000
            config.enable_scroll_bar = true

            -- Tab bar
            config.enable_tab_bar = true
            config.hide_tab_bar_if_only_one_tab = false
            config.use_fancy_tab_bar = false
            config.tab_bar_at_bottom = false
            config.tab_max_width = 32
            config.show_tab_index_in_tab_bar = true
            config.switch_to_last_active_tab_when_closing_tab = true

            -- Window
            config.window_padding = {
              left = 2,
              right = 2,
              top = 2,
              bottom = 2,
            }
            config.window_decorations = "NONE"
            config.window_close_confirmation = 'AlwaysPrompt'
            config.adjust_window_size_when_changing_font_size = false
            config.initial_cols = 120
            config.initial_rows = 30

            -- Performance
            config.max_fps = 120
            config.animation_fps = 60
            config.front_end = "OpenGL"
            config.enable_wayland = true

            -- Bell
            config.audible_bell = "Disabled"
            config.visual_bell = {
              fade_in_function = 'EaseIn',
              fade_in_duration_ms = 150,
              fade_out_function = 'EaseOut',
              fade_out_duration_ms = 150,
            }

            -- Misc
            config.automatically_reload_config = true
            config.check_for_updates = false
            config.use_dead_keys = false
            config.warn_about_missing_glyphs = false
            config.enable_kitty_graphics = true
            config.enable_kitty_keyboard = true
            config.allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace"

            -- Keybindings
            config.keys = {
              -- Tab management
              { key = 't', mods = 'CTRL|SHIFT', action = act.SpawnTab 'CurrentPaneDomain' },
              { key = 'w', mods = 'CTRL|SHIFT', action = act.CloseCurrentTab{ confirm = true } },
              { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
              { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
              { key = ']', mods = 'ALT', action = act.ActivateTabRelative(1) },
              { key = '[', mods = 'ALT', action = act.ActivateTabRelative(-1) },
              
              -- Tab navigation by number
              { key = '1', mods = 'ALT', action = act.ActivateTab(0) },
              { key = '2', mods = 'ALT', action = act.ActivateTab(1) },
              { key = '3', mods = 'ALT', action = act.ActivateTab(2) },
              { key = '4', mods = 'ALT', action = act.ActivateTab(3) },
              { key = '5', mods = 'ALT', action = act.ActivateTab(4) },
              { key = '6', mods = 'ALT', action = act.ActivateTab(5) },
              { key = '7', mods = 'ALT', action = act.ActivateTab(6) },
              { key = '8', mods = 'ALT', action = act.ActivateTab(7) },
              { key = '9', mods = 'ALT', action = act.ActivateTab(8) },
              
              -- Pane splitting
              { key = '"', mods = 'CTRL|SHIFT', action = act.SplitVertical{ domain = 'CurrentPaneDomain' } },
              { key = '%', mods = 'CTRL|SHIFT', action = act.SplitHorizontal{ domain = 'CurrentPaneDomain' } },
              { key = 'h', mods = 'CTRL|SHIFT', action = act.SplitHorizontal{ domain = 'CurrentPaneDomain' } },
              { key = 'v', mods = 'CTRL|SHIFT', action = act.SplitVertical{ domain = 'CurrentPaneDomain' } },
              
              -- Pane navigation
              { key = 'LeftArrow', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Left' },
              { key = 'RightArrow', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Right' },
              { key = 'UpArrow', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Up' },
              { key = 'DownArrow', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Down' },
              
              -- Pane resizing
              { key = 'LeftArrow', mods = 'CTRL|SHIFT|ALT', action = act.AdjustPaneSize{ 'Left', 5 } },
              { key = 'RightArrow', mods = 'CTRL|SHIFT|ALT', action = act.AdjustPaneSize{ 'Right', 5 } },
              { key = 'UpArrow', mods = 'CTRL|SHIFT|ALT', action = act.AdjustPaneSize{ 'Up', 5 } },
              { key = 'DownArrow', mods = 'CTRL|SHIFT|ALT', action = act.AdjustPaneSize{ 'Down', 5 } },
              
              -- Close pane
              { key = 'x', mods = 'CTRL|SHIFT', action = act.CloseCurrentPane{ confirm = true } },
              { key = 'q', mods = 'CTRL|SHIFT', action = act.QuitApplication },
              
              -- Font size
              { key = '+', mods = 'CTRL', action = act.IncreaseFontSize },
              { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
              { key = '0', mods = 'CTRL', action = act.ResetFontSize },
              
              -- Copy/Paste
              { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo 'Clipboard' },
              { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },
              
              -- Scrollback
              { key = 'PageUp', mods = 'SHIFT', action = act.ScrollByPage(-1) },
              { key = 'PageDown', mods = 'SHIFT', action = act.ScrollByPage(1) },
              
              -- Search
              { key = 'f', mods = 'CTRL|SHIFT', action = act.Search 'CurrentSelectionOrEmptyString' },
              
              -- Command palette
              { key = 'p', mods = 'CTRL|SHIFT', action = act.ActivateCommandPalette },
              
              -- Toggle fullscreen
              { key = 'F11', mods = 'NONE', action = act.ToggleFullScreen },
              
              -- Quick select mode (for URLs, paths, etc.)
              { key = 'Space', mods = 'CTRL|SHIFT', action = act.QuickSelect },
              
              -- Copy mode (vim-like navigation)
              { key = 'X', mods = 'CTRL|SHIFT', action = act.ActivateCopyMode },
              
              -- Show launcher menu
              { key = 'l', mods = 'CTRL|SHIFT', action = act.ShowLauncher },
              
              -- Clear scrollback
              { key = 'k', mods = 'CTRL|SHIFT', action = act.ClearScrollback 'ScrollbackAndViewport' },
            }

            -- Mouse bindings
            config.mouse_bindings = {
              -- Change the default click behavior so that it only selects text and doesn't open hyperlinks
              {
                event = { Up = { streak = 1, button = 'Left' } },
                mods = 'NONE',
                action = act.CompleteSelection 'ClipboardAndPrimarySelection',
              },
              -- Open hyperlinks with Ctrl+Click
              {
                event = { Up = { streak = 1, button = 'Left' } },
                mods = 'CTRL',
                action = act.OpenLinkAtMouseCursor,
              },
              -- Paste on right click
              {
                event = { Down = { streak = 1, button = 'Right' } },
                mods = 'NONE',
                action = act.PasteFrom 'Clipboard',
              },
              -- Disable middle mouse button paste
              {
                event = { Down = { streak = 1, button = 'Middle' } },
                mods = 'NONE',
                action = act.Nop,
              },
            }

            -- Startup configuration with multiple tabs and split pane
            wezterm.on('gui-startup', function(cmd)
              local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
              
              -- First tab: zsh (top) and bash (bottom) split
              pane:send_text 'clear && ${lib.getExe pkgs.zsh}\n'
              local bash_pane = pane:split{ direction = 'Bottom', size = 0.5 }
              bash_pane:send_text 'clear && ${lib.getExe pkgs.bash}\n'
              tab:set_title('zsh/bash')
              
              -- Activate the top pane (zsh/bash)
              pane:activate()
              
              -- Tab 2: btop
              local tab2, pane2, window2 = window:spawn_tab{}
              pane2:send_text '${lib.getExe pkgs.btop}\n'
              tab2:set_title('btop')
              
              -- Tab 3: nvtop
              local tab3, pane3, window3 = window:spawn_tab{}
              pane3:send_text '${lib.getExe pkgs.nvtopPackages.amd}\n'
              tab3:set_title('nvtop')
              
              -- Tab 4: kmon
              local tab4, pane4, window4 = window:spawn_tab{}
              pane4:send_text '${lib.getExe pkgs.kmon}\n'
              tab4:set_title('kmon')
              
              -- Tab 5: yazi
              local tab5, pane5, window5 = window:spawn_tab{}
              pane5:send_text '${lib.getExe pkgs.yazi}\n'
              tab5:set_title('yazi')
              
              -- Tab 6: sshs
              local tab6, pane6, window6 = window:spawn_tab{}
              pane6:send_text '${lib.getExe pkgs.sshs}\n'
              tab6:set_title('sshs')
              
              -- Tab 7: distrobox with automatic container splits
              local tab7, pane7, window7 = window:spawn_tab{}
              
              -- Get list of distrobox containers
              local success, stdout, stderr = wezterm.run_child_process({
                '${lib.getExe' config.programs.distrobox.package "distrobox"}', 'list', '--no-color'
              })
              
              if success then
                local containers = {}
                -- Parse distrobox list output, skip header lines
                local lines = {}
                for line in stdout:gmatch("[^\r\n]+") do
                  table.insert(lines, line)
                end
                
                -- Extract container names (first column after header)
                for i = 2, #lines do
                  local name = lines[i]:match("^(%S+)")
                  if name and name ~= "" and name ~= "ID" and name ~= "NAME" then
                    table.insert(containers, name)
                  end
                end
                
                if #containers > 0 then
                  -- Enter first container in the main pane
                  pane7:send_text('${lib.getExe' config.programs.distrobox.package "distrobox-enter"} ' .. containers[1] .. '\n')
                  
                  -- Create splits for additional containers
                  local current_pane = pane7
                  for i = 2, #containers do
                    if i == 2 then
                      -- First split: vertical
                      current_pane = pane7:split{ direction = 'Right', size = 0.5 }
                    elseif i == 3 then
                      -- Second split: horizontal from first pane
                      current_pane = pane7:split{ direction = 'Bottom', size = 0.5 }
                    elseif i == 4 then
                      -- Third split: horizontal from second pane (right side)
                      current_pane = current_pane:split{ direction = 'Bottom', size = 0.5 }
                    else
                      -- Additional containers: continue splitting
                      current_pane = current_pane:split{ direction = 'Bottom', size = 0.5 }
                    end
                    current_pane:send_text('${lib.getExe' config.programs.distrobox.package "distrobox-enter"} ' .. containers[i] .. '\n')
                  end
                  
                  tab7:set_title('distrobox (' .. #containers .. ')')
                else
                  -- No containers found, just show distrobox list
                  pane7:send_text('${lib.getExe' config.programs.distrobox.package "distrobox"} list\n')
                  tab7:set_title('distrobox')
                end
              else
                -- distrobox command failed, show error
                pane7:send_text('echo "Error: Could not list distrobox containers"\n')
                pane7:send_text('${lib.getExe' config.programs.distrobox.package "distrobox"} list\n')
                tab7:set_title('distrobox')
              end

              -- Tab 8: fastfetch
              local tab8, pane8, window8 = window:spawn_tab{}
              pane8:send_text '${lib.getExe pkgs.fastfetch}\n'
              tab8:set_title('fastfetch')
              
              -- Tab 9: eilmeldung
              local tab9, pane9, window9 = window:spawn_tab{}
              pane9:send_text '${lib.getExe pkgs.eilmeldung}\n'
              tab9:set_title('rss')
              
              -- Tab 10: neo
              local tab10, pane10, window10 = window:spawn_tab{}
              pane10:send_text '${lib.getExe pkgs.neo} -Da -b 2\n'
              tab10:set_title('neo')
              
              -- Go back to first tab
              tab:activate()
            end)

            -- Format tab titles
            wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
              -- Catppuccin Mocha colors
              local edge_background = '#1e1e2e' -- base
              local background = '#313244' -- surface0
              local foreground = '#cdd6f4' -- text

              if tab.is_active then
                background = '#b4befe' -- lavender
                foreground = '#1e1e2e' -- base
              elseif hover then
                background = '#45475a' -- surface1
                foreground = '#cdd6f4' -- text
              end

              local edge_foreground = background

              local title = tab.tab_title
              if title and #title > 0 then
                title = ' ' .. title .. ' '
              else
                title = ' ' .. tab.active_pane.title .. ' '
              end

              return {
                { Background = { Color = edge_background } },
                { Foreground = { Color = edge_foreground } },
                { Text = ''' },
                { Background = { Color = background } },
                { Foreground = { Color = foreground } },
                { Text = title },
                { Background = { Color = edge_background } },
                { Foreground = { Color = edge_foreground } },
                { Text = ''' },
              }
            end)

            -- Update right status with current key mode
            wezterm.on('update-right-status', function(window, pane)
              local date = wezterm.strftime '%Y-%m-%d %H:%M:%S'
              local battery = '''
              
              for _, b in ipairs(wezterm.battery_info()) do
                battery = string.format('%.0f%%', b.state_of_charge * 100)
              end

              window:set_right_status(wezterm.format {
                { Text = battery .. ' | ' .. date .. ' ' },
              })
            end)

            return config
          '';
        };
      };
  };
}
