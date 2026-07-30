{
  flake.modules.homeManager.base-profile = {
    programs.fastfetch = {
      enable = true;
      settings = {
        display = {
          separator = " ";
        };
        modules = [
          {
            keyWidth = 10;
            type = "title";
          }
          {
            format = "{pretty-name}";
            key = " OS";
            keyColor = "yellow";
            type = "os";
          }
          {
            key = "├ Kernel";
            keyColor = "yellow";
            type = "kernel";
          }
          {
            key = "├󰏖 Packages";
            keyColor = "yellow";
            type = "packages";
          }
          {
            key = "├ Shell";
            keyColor = "yellow";
            type = "shell";
          }
          {
            key = "├ Boot Manager";
            keyColor = "yellow";
            type = "bootmgr";
          }
          "break"
          {
            key = "󰧨 DE";
            keyColor = "blue";
            type = "de";
          }
          {
            key = "├󰧨 Window Manager";
            keyColor = "blue";
            type = "wm";
          }
          {
            key = "├󰧨 Login Manager";
            keyColor = "blue";
            type = "lm";
          }
          {
            key = "├󰉼 WM Theme";
            keyColor = "blue";
            type = "wmtheme";
          }
          {
            key = "├󰉼 Color Theme";
            keyColor = "blue";
            type = "theme";
          }
          {
            key = "├󰇀 Cursor Theme";
            keyColor = "blue";
            type = "cursor";
          }
          {
            key = "├󰸉 System Icon";
            keyColor = "blue";
            type = "icons";
          }
          {
            key = "├ System Font";
            keyColor = "blue";
            type = "font";
          }
          {
            key = "├ Terminal";
            keyColor = "blue";
            type = "terminal";
          }
          {
            key = "└ Terminal Font";
            keyColor = "blue";
            type = "terminalfont";
          }
          "break"
          {
            key = "󰌢 PC";
            keyColor = "green";
            type = "chassis";
          }
          {
            key = "├ Board";
            keyColor = "green";
            type = "board";
          }
          {
            key = "├󰍛 BIOS";
            keyColor = "green";
            type = "bios";
          }
          {
            format = "{name} ({cores-physical}C/{cores-logical}T) @ {freq-max}";
            key = "├󰻠 CPU";
            keyColor = "green";
            type = "cpu";
          }
          {
            key = "├󰍛 GPU";
            keyColor = "green";
            type = "gpu";
          }
          {
            key = "├󰑭 RAM";
            keyColor = "green";
            type = "memory";
          }
          {
            key = "├󰓡 Swap";
            keyColor = "green";
            type = "swap";
          }
          {
            format = "{mountpoint} [{size-free} / {size-total}] ({filesystem})";
            key = "├ Disk";
            keyColor = "green";
            type = "disk";
          }
          {
            format = "{name} [{width}x{height}] @ {refresh-rate}Hz{?hdr-compatible} 󰵽{?} {?is-primary}*{?}";
            key = "├󰍹 Display";
            keyColor = "green";
            type = "display";
          }
          {
            key = "├󰍛 Vulkan";
            keyColor = "green";
            type = "vulkan";
          }
          {
            key = "└󰍛 OpenGL";
            keyColor = "green";
            type = "opengl";
          }
        ];
      };
    };
  };
}
