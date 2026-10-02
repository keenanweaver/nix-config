{ lib, ... }:
let
  esc = glyph "001b";
  glyph = code: builtins.fromJSON ''"\u${code}"'';
  hr = n: c: lib.concatStrings (lib.replicate n c);
  keyWidth = 15;
  left = n: "${esc}[${toString n}D";
  restore = "${esc}[u";
  right = n: "${esc}[${toString n}C";
  save = "${esc}[s";
  section =
    color: title: rows:
    [
      {
        format = "{#bright_${color}} ${title} ";
        key = "{#${color}}${hr width "─"}${titleAt title}";
        type = "custom";
      }
    ]
    ++ map (
      { label, ... }@module:
      removeAttrs module [ "label" ]
      // {
        key = "{#${color}}${save}{icon}  ${label}${restore}${right keyWidth}{#}";
      }
    ) rows;
  titleAt = title: left (width - (width - lib.stringLength title - 1) / 2);
  width = 80;
in
{
  flake.modules.homeManager.profile-base =
    { pkgs, ... }:
    {
      programs.fastfetch = {
        enable = true;
        settings = {
          display.separator = "";
          logo = {
            height = 15;
            padding.top = 1;
            source = ../../assets/theming/nix-catppuccin-logo.png;
            type = "kitty";
          };
          modules =
            section "white" "System" [
              {
                format = "{pretty-name}";
                label = "OS";
                type = "os";
              }
              {
                label = "Kernel";
                type = "kernel";
              }
              {
                label = "Boot Mgr";
                type = "bootmgr";
              }
              {
                label = "Packages";
                type = "packages";
              }
              {
                format = "{year}-{month-pretty}-{day-pretty} {hour-pretty}:{minute-pretty}:{second-pretty} {timezone-name}";
                label = "Fetched";
                type = "datetime";
              }
              {
                label = "Uptime";
                type = "uptime";
              }
            ]
            ++ section "blue" "NixOS" [
              {
                format = "nix {~10}";
                keyIcon = glyph "f313";
                label = "Nix";
                text = "nix --version";
                type = "command";
              }
              {
                keyIcon = glyph "f1da";
                label = "Generation";
                text = ''
                  l=$(readlink /nix/var/nix/profiles/system); n=''${l#system-}
                  printf '%s (%s)' "''${n%-link}" "$(stat -c %y "/nix/var/nix/profiles/$l" | cut -d. -f1)"
                  [ "$(readlink -f /run/current-system)" = "$(readlink -f /nix/var/nix/profiles/system)" ] || printf ' [not running]'
                '';
                type = "command";
              }
              {
                keyIcon = glyph "f126";
                label = "Revision";
                text = "nixos-version --configuration-revision | sed -E 's/^([0-9a-f]{12})[0-9a-f]*/\\1/'";
                type = "command";
              }
              {
                keyIcon = glyph "f1b2";
                label = "Nixpkgs";
                text = "nixos-version";
                type = "command";
              }
              {
                keyIcon = glyph "f0e8";
                label = "Specs";
                text = "nixos-version --specialisations | paste -sd, | sed 's/,/, /g'";
                type = "command";
              }
              {
                folders = "/nix";
                format = "{create-time:10} [{days} days]";
                keyIcon = glyph "f073";
                label = "OS Age";
                type = "disk";
              }
            ]
            ++ section "cyan" "Hardware" [
              {
                label = "PC";
                type = "chassis";
              }
              {
                label = "Board";
                type = "board";
              }
              {
                label = "BIOS";
                type = "bios";
              }
              {
                format = "{name} ({cores-physical}C/{cores-logical}T) @ {freq-max}";
                label = "CPU";
                type = "cpu";
              }
              {
                compact = true;
                label = "CPU Cache";
                type = "cpucache";
              }
              {
                label = "RAM";
                type = "memory";
              }
              {
                label = "Swap";
                type = "swap";
              }
              {
                format = "{mountpoint} [{size-free} / {size-total}] ({filesystem})";
                label = "Disk";
                type = "disk";
              }
              {
                label = "Battery";
                type = "battery";
              }
              {
                label = "Sound";
                type = "sound";
              }
            ]
            ++ section "green" "Desktop" [
              {
                label = "Desktop";
                type = "de";
              }
              {
                label = "WM";
                type = "wm";
              }
              {
                label = "Login Mgr";
                type = "lm";
              }
              {
                format = "{name} [{width}x{height}] @ {refresh-rate}Hz{?hdr-compatible} 󰵽{?} {?is-primary}*{?}";
                label = "Display";
                type = "display";
              }
              {
                label = "WM Theme";
                type = "wmtheme";
              }
              {
                label = "Theme";
                type = "theme";
              }
              {
                label = "Cursor";
                type = "cursor";
              }
              {
                label = "Icons";
                type = "icons";
              }
              {
                label = "Font";
                type = "font";
              }
            ]
            ++ section "yellow" "Terminal" [
              {
                label = "Shell";
                type = "shell";
              }
              {
                label = "Terminal";
                type = "terminal";
              }
              {
                label = "Term Font";
                type = "terminalfont";
              }
              {
                label = "Editor";
                type = "editor";
              }
            ]
            ++ section "red" "Graphics" [
              {
                driverSpecific = true;
                format = "{name} [{type}] {dedicated-total}";
                label = "GPU";
                type = "gpu";
              }
              {
                keyIcon = glyph "f2db";
                label = "Driver";
                text = "${lib.getExe pkgs.drm_info} | sed -n 's/.*Driver: \\([^ ]*\\) .*version \\(.*\\)/\\1 \\2/p' | head -n1";
                type = "command";
              }
              {
                keyIcon = glyph "f085";
                label = "VBIOS";
                text = "cat /sys/class/drm/card*/device/vbios_version 2>/dev/null | head -n1";
                type = "command";
              }
              {
                label = "Vulkan";
                type = "vulkan";
              }
              {
                label = "OpenGL";
                type = "opengl";
              }
            ]
            ++ [
              "break"
              "colors"
            ];
        };
      };
    };
}
