{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.fastfetch;
in
{
  options = {
    fastfetch = {
      enable = lib.mkEnableOption "Enable fastfetch in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.fastfetch = {
        enable = true;
        settings = {
          display = {
            separator = " ";
          };
          modules = [
            {
              type = "title";
              keyWidth = 10;
            }
            {
              format = "{pretty-name}";
              type = "os";
              key = " OS";
              keyColor = "yellow";
            }
            {
              type = "kernel";
              key = "├ Kernel";
              keyColor = "yellow";
            }
            {
              type = "packages";
              key = "├󰏖 Packages";
              keyColor = "yellow";
            }
            {
              type = "shell";
              key = "├ Shell";
              keyColor = "yellow";
            }
            {
              type = "bootmgr";
              key = "├ Boot Manager";
              keyColor = "yellow";
            }
            "break"
            {
              type = "de";
              key = "󰧨 DE";
              keyColor = "blue";
            }
            {
              type = "wm";
              key = "├󰧨 Window Manager";
              keyColor = "blue";
            }
            {
              type = "lm";
              key = "├󰧨 Login Manager";
              keyColor = "blue";
            }
            {
              type = "wmtheme";
              key = "├󰉼 WM Theme";
              keyColor = "blue";
            }
            {
              type = "theme";
              key = "├󰉼 Color Theme";
              keyColor = "blue";
            }
            {
              type = "cursor";
              key = "├󰇀 Cursor Theme";
              keyColor = "blue";
            }
            {
              type = "icons";
              key = "├󰸉 System Icon";
              keyColor = "blue";
            }
            {
              type = "font";
              key = "├ System Font";
              keyColor = "blue";
            }
            {
              type = "terminal";
              key = "├ Terminal";
              keyColor = "blue";
            }
            {
              type = "terminalfont";
              key = "└ Terminal Font";
              keyColor = "blue";
            }
            "break"
            {
              type = "chassis";
              key = "󰌢 PC";
              keyColor = "green";
            }
            {
              type = "board";
              key = "├ Board";
              keyColor = "green";
            }
            {
              type = "bios";
              key = "├󰍛 BIOS";
              keyColor = "green";
            }
            {
              format = "{name} ({cores-physical}C/{cores-logical}T) @ {freq-max}";
              type = "cpu";
              key = "├󰻠 CPU";
              keyColor = "green";
            }
            {
              type = "gpu";
              key = "├󰍛 GPU";
              keyColor = "green";
            }
            {
              type = "memory";
              key = "├󰑭 RAM";
              keyColor = "green";
            }
            {
              type = "swap";
              key = "├󰓡 Zram";
              keyColor = "green";
            }
            {
              format = "{mountpoint} [{size-free} / {size-total}] ({filesystem})";
              type = "disk";
              key = "├ Disk";
              keyColor = "green";
            }
            {
              format = "{name} [{width}x{height}] @ {refresh-rate}Hz{?hdr-compatible} 󰵽{?} {?is-primary}*{?}";
              type = "display";
              key = "├󰍹 Display";
              keyColor = "green";
            }
            {
              type = "vulkan";
              key = "├󰍛 Vulkan";
              keyColor = "green";
            }
            {
              type = "opengl";
              key = "└󰍛 OpenGL";
              keyColor = "green";
            }
          ];
        };
      };
    };
  };
}
