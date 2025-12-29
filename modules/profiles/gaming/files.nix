{
  pkgs,
  inputs,
  config,
  osConfig,
  ...
}:
let
  primaryscreen = "DP-1";
in
{
  desktop-entry-dxvk = {
    enable = false;
    text = ''
      [Desktop Entry]
      Comment=Create a new DXVK config from template
      Icon=text-plain
      Name=DXVK Config...
      Type=Link
      URL[$e]=file:${
        pkgs.writeText "dxvk.conf" (
          builtins.readFile (
            pkgs.fetchurl {
              url = "https://raw.githubusercontent.com/doitsujin/dxvk/master/dxvk.conf";
              hash = "sha256-UiCSte2pEBgg21ERVj+LSsY8I/8RKyySwzDvnopJRVI=";
            }
          )
        )
      }
    '';
    target = "${config.xdg.dataHome}/templates/dxvk.desktop";
  };
  desktop-entry-mangohud = {
    enable = false;
    text = ''
      [Desktop Entry]
      Comment=Create a new MangoHud config from template
      Icon=io.github.flightlessmango.mangohud
      Name=MangoHud Config...
      Type=Link
      URL[$e]=file:${
        pkgs.writeText "MangoHud.conf" (
          builtins.readFile (
            pkgs.fetchurl {
              url = "https://raw.githubusercontent.com/flightlessmango/MangoHud/master/data/MangoHud.conf";
              hash = "sha256-v4HdqQtJBvPR19SNf+FxoV5wJ+0Ou/1UYAkIwskXIWc=";
            }
          )
        )
      }
    '';
    target = "${config.xdg.dataHome}/templates/mangohud.desktop";
  };
  desktop-entry-vkBasalt = {
    enable = false;
    text = ''
      [Desktop Entry]
      Comment=Create a new vkBasalt config from template
      Icon=text-plain
      Name=vkBasalt Config...
      Type=Link
      URL[$e]=file:${
        pkgs.writeText "vkBasalt.conf" (
          builtins.readFile (
            pkgs.fetchurl {
              url = "https://raw.githubusercontent.com/DadSchoorse/vkBasalt/master/config/vkBasalt.conf";
              hash = "sha256-IN/Kuc17EZfzRoo8af1XoBX2/48/bCdyOxw/Tl463Mg=";
            }
          )
        )
      }
    '';
    target = "${config.xdg.dataHome}/templates/vkBasalt.desktop";
  };
  dosbox-roms-mt32 = {
    enable = true;
    source = "${inputs.nonfree}/Music/roland/mt32";
    target = "${config.xdg.configHome}/dosbox/mt32-roms";
  };
  dosbox-roms-sc55 = {
    enable = true;
    source = "${inputs.nonfree}/Music/roland/sc55";
    target = "${config.xdg.configHome}/dosbox/soundcanvas-roms";
  };
  dosbox-soundfont = {
    enable = true;
    source = osConfig.fluidsynth.soundFont;
    target = "${config.xdg.configHome}/dosbox/soundfonts/default.sf2";
  };
  screen-hdr-off = {
    enable = true;
    source =
      with pkgs;
      lib.getExe (writeShellApplication {
        name = "hdr-off";
        runtimeInputs = [
          kdePackages.libkscreen
        ];
        text = ''
          kscreen-doctor output.${primaryscreen}.hdr.disable output.${primaryscreen}.wcg.disable
        '';
      });
    target = "${config.home.homeDirectory}/Games/hdr-off.sh";
  };
  screen-hdr-on = {
    enable = true;
    source =
      with pkgs;
      lib.getExe (writeShellApplication {
        name = "hdr-on";
        runtimeInputs = [
          kdePackages.libkscreen
        ];
        text = ''
          kscreen-doctor output.${primaryscreen}.hdr.enable output.${primaryscreen}.wcg.enable
        '';
      });
    target = "${config.home.homeDirectory}/Games/hdr-on.sh";
  };
  screen-vrr-off = {
    enable = true;
    source =
      with pkgs;
      lib.getExe (writeShellApplication {
        name = "vrr-off";
        runtimeInputs = [
          kdePackages.libkscreen
        ];
        text = ''
          kscreen-doctor output.${primaryscreen}.vrrpolicy.never
        '';
      });
    target = "${config.home.homeDirectory}/Games/vrr-off.sh";
  };
  screen-vrr-on = {
    enable = true;
    source =
      with pkgs;
      lib.getExe (writeShellApplication {
        name = "vrr-on";
        runtimeInputs = [
          kdePackages.libkscreen
        ];
        text = ''
          kscreen-doctor output.${primaryscreen}.vrrpolicy.automatic
        '';
      });
    target = "${config.home.homeDirectory}/Games/vrr-on.sh";
  };
  wine-controller-proton = {
    # https://selfmadepenguin.wordpress.com/2024/02/14/how-i-solved-my-gamecontroller-problems/
    # Import with: wine start regedit.exe ~/Games/wine-controller.reg
    enable = false;
    text = ''
      Windows Registry Editor Version 5.00

      [HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\winebus]
      "DisableHidraw"=dword:00000001
      "Enable SDL"=dword:00000001
    '';
    target = "${config.home.homeDirectory}/Games/wine-controller.reg";
  };
  wine-mouse-acceleration = {
    # https://reddit.com/r/linux_gaming/comments/1hs1685/windows_mouse_acceleration_seems_to_be_enabled_in/
    # Import with: wine start regedit.exe ~/Games/wine-mouse-acceleration.reg
    enable = false;
    text = ''
      Windows Registry Editor Version 5.00

      [HKEY_CURRENT_USER\Control Panel\Mouse]
      "MouseSpeed"="0"
      "MouseThreshold1"="0"
      "MouseThreshold2"="0"
    '';
    target = "${config.home.homeDirectory}/Games/wine-mouse-acceleration.reg";
  };
}
