{ config, lib, pkgs, username, ... }:
let
  cfg = config.gaming;
in
{
  options = {
    gaming = {
      enable = lib.mkEnableOption "Enable Gaming module in NixOS";
      copyROMS = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    # Custom modules
    cdemu.enable = true;
    corectrl.enable = true;
    fluidsynth.enable = true;
    gamemode.enable = true;
    gamescope.enable = true;
    gpu-screen-recorder.enable = true;
    mangohud.enable = true;
    steam.enable = true;
    timidity.enable = true;
    zerotier.enable = true;

    environment = {
      sessionVariables = {
        # https://reddit.com/r/linux_gaming/comments/1b9foom/workaround_for_cursor_movement_cutting_our_vrr_on/
        KWIN_DRM_DELAY_VRR_CURSOR_UPDATES = "1";
        KWIN_FORCE_SW_CURSOR = "1";
        OBS_VKCAPTURE_QUIET = "1";
        SDL_SOUNDFONTS = "/home/${username}/Music/soundfonts/default.sf2";
      };
    };

    hardware = {
      logitech = {
        wireless = {
          enable = true;
        };
      };
      new-lg4ff.enable = true;
      uinput.enable = true;
      xone.enable = true;
      xpadneo.enable = true;
    };

    networking = {
      firewall = {
        allowedTCPPorts = [
          47984 # Sunshine
          47989
          47990
          48010
          59999 # MoonDeck Buddy
        ];
        allowedTCPPortRanges = [
          { from = 45000; to = 45010; } # simple64 server
        ];
        allowedUDPPorts = [
          59999 # MoonDeck Buddy
          9993 # ZeroTier
        ];
        allowedUDPPortRanges = [
          { from = 45000; to = 45010; } # simple64 server
          { from = 47998; to = 48000; } # sunshine
        ];
      };
    };

    services = {
      hardware = {
        openrgb = {
          enable = true;
          package = pkgs.openrgb-with-all-plugins;
        };
      };
      input-remapper.enable = true;
      joycond.enable = true;
      system76-scheduler.enable = true;
      udev = {
        packages = [
          pkgs.game-devices-udev-rules
          # xpad for 8BitDo Ultimate Wireless https://github.com/SKyletoft/dots/commit/8825e58d24a79f48afed65bef84bd9295e5e3ea3
          (pkgs.writeTextFile {
            name = "50-xpad-8bitdo-ultimate-wireless.rules";
            text = ''
              ACTION=="add", \
               	ATTRS{idVendor}=="2dc8", \
               	ATTRS{idProduct}=="3106", \
               	RUN+="${pkgs.kmod}/bin/modprobe xpad", \
               	RUN+="${pkgs.bash}/bin/sh -c 'echo 2dc8 3106 > /sys/bus/usb/drivers/xpad/new_id'"
            '';
            destination =
              "/etc/udev/rules.d/50-xpad-8bitdo-ultimate-wireless.rules";
          })
          # AntiMicroX / SC-Controller https://github.com/AntiMicroX/antimicrox/wiki/Open-uinput-error
          (pkgs.writeTextFile {
            name = "60-antimicrox-uinput.rules";
            text = ''
              SUBSYSTEM=="misc", KERNEL=="uinput", TAG+="uaccess"
            '';
            destination = "/etc/udev/rules.d/60-antimicrox-uinput.rules";
          })
          # Dualsense touchpad https://wiki.archlinux.org/title/Gamepad#Motion_controls_taking_over_joypad_controls_and/or_causing_unintended_input_with_joypad_controls
          (pkgs.writeTextFile {
            name = "51-disable-DS3-and-DS4-motion-controls.rules";
            text = ''
              SUBSYSTEM=="input", ATTRS{name}=="*Controller Motion Sensors", RUN+="${pkgs.coreutils}/bin/rm %E{DEVNAME}", ENV{ID_INPUT_JOYSTICK}=""
              #SUBSYSTEM=="input", ATTRS{name}=="*Controller Touchpad", RUN+="${pkgs.coreutils}/bin/rm %E{DEVNAME}", ENV{ID_INPUT_JOYSTICK}=""
            '';
            destination =
              "/etc/udev/rules.d/51-disable-DS3-and-DS4-motion-controls.rules";
          })
        ];
      };
    };
    home-manager.users.${username} = { inputs, config, username, pkgs, ... }: {
      home.file = {
        roms-amiga = {
          enable = true;
          recursive = true;
          source = config.lib.file.mkOutOfStoreSymlink "${inputs.nonfree}/ROMs/amiga";
          target = ".var/app/net.fsuae.FS-UAE/data/fs-uae";
        };
        roms-fightcade = {
          enable = true;
          recursive = true;
          source = config.lib.file.mkOutOfStoreSymlink "${inputs.nonfree}/ROMs/fightcade";
          target = ".var/app/com.fightcade.Fightcade/data";
        };
        roms-dolphin = {
          enable = true;
          source = config.lib.file.mkOutOfStoreSymlink "${inputs.nonfree}/ROMs/dolphin/USA/IPL.bin";
          target = ".var/app/org.DolphinEmu.dolphin-emu/data/dolphin-emu/GC/USA/IPL.bin";
        };
        roms-mt32 = {
          enable = true;
          recursive = true;
          source = config.lib.file.mkOutOfStoreSymlink "${inputs.nonfree}/Music/mt-32";
          target = "Music/mt-32";
        };
        roms-mt32-exodos = {
          enable = true;
          recursive = true;
          source = config.lib.file.mkOutOfStoreSymlink "${inputs.nonfree}/Music/mt-32";
          target = "${config.xdg.configHome}/distrobox/bazzite-arch-exodos/.config/dosbox/mt32-roms";
        };
        roms-duckstation = {
          enable = true;
          recursive = true;
          source = config.lib.file.mkOutOfStoreSymlink "${inputs.nonfree}/ROMs/ps1";
          target = ".var/app/org.duckstation.DuckStation/config/duckstation/bios";
        };
        roms-pcsx2 = {
          enable = true;
          recursive = true;
          source = config.lib.file.mkOutOfStoreSymlink "${inputs.nonfree}/ROMs/ps2";
          target = ".var/app/net.pcsx2.PCSX2/config/PCSX2/bios";
        };
        roms-retroarch = {
          enable = true;
          recursive = true;
          source = config.lib.file.mkOutOfStoreSymlink "${inputs.nonfree}/ROMs/retroarch";
          target = ".var/app/org.libretro.RetroArch/config/retroarch/system";
        };
        roms-xemu-mcpx = {
          enable = true;
          source = config.lib.file.mkOutOfStoreSymlink "${inputs.nonfree}/ROMs/xbox/mcpx_1.0.bin";
          target = ".var/app/app.xemu.xemu/data/xemu/xemu/mcpx_1.0.bin";
        };
        roms-xemu-bios = {
          enable = true;
          source = config.lib.file.mkOutOfStoreSymlink "${inputs.nonfree}/ROMs/xbox/xbox-4627_debug.bin";
          target = ".var/app/app.xemu.xemu/data/xemu/xemu/xbox-4627_debug.bin";
        };
      };
      home.packages = with pkgs; [
        #############
        ## Gaming ##
        ############
        ## Launchers
        bottles
        heroic
        lutris
        ## Emulators
        #bizhawk
        #hypseus-singe
        #mesen
        ## Modding
        r2modman
        ## Doom
        #chocolate-doom
        crispy-doom
        #doom64ex-plus
        (callPackage ../../nix/pkgs/doom64ex-plus.nix { })
        doomrunner
        doomseeker
        dsda-doom
        gzdoom
        prboom-plus
        rbdoom-3-bfg
        zandronum
        zandronum-server
        ## Quake
        ironwail
        quake3e
        #trenchbroom
        ## Fallout
        fallout-ce
        fallout2-ce
        ## Freespace
        dxx-rebirth
        knossosnet
        ## N64
        #shipwright
        #sm64ex
        ## Ultima
        exult
        # Wipeout
        wipeout-rewrite
        ## Wolf3D
        bstone
        ecwolf
        lzwolf
        ## Other
        alephone
        alephone-marathon
        alephone-durandal
        alephone-infinity
        arx-libertatis
        openjk
        openloco
        openxray
        inputs.nix-citizen.packages.${system}.star-citizen
        inputs.nix-citizen.packages.${system}.star-citizen-helper
        ## Input
        joystickwake
        makima
        oversteer
        sc-controller
        xboxdrv
        ## Tools
        glxinfo
        gst_all_1.gstreamer
        gst_all_1.gst-libav
        gst_all_1.gst-plugins-bad
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        gst_all_1.gst-plugins-ugly
        libstrangle
        obs-studio-plugins.obs-vkcapture
        vkbasalt
        vulkan-tools
        winetricks
        wineWowPackages.stagingFull
        ## One and dones ##
        /*  igir
            innoextract
            jpsxdec
            lgogdownloader
            mame.tools
            mkvtoolnix-cli
            mmv
            nsz
            oxyromon
            ps3-disc-dumper
            vgmplay-libvgm
            vgmstream
            vgmtools 
          */
      ];
      # Move config files out of home
      programs.boxxy = {
        rules = [
          {
            name = "exult directory";
            target = "/home/${username}/.exult";
            rewrite = "${config.xdg.configHome}/exult";
          }
          {
            name = "exult config file";
            target = "/home/${username}/.exult.cfg";
            rewrite = "${config.xdg.configHome}/exult/exult.cfg";
            mode = "file";
          }
        ];
      };
      xdg = {
        desktopEntries = {
          dosbox = {
            name = "dosbox-staging";
            comment = "DOSBox Staging";
            exec = "dosbox";
            icon = "dosbox-staging";
            categories = [ "Game" ];
            noDisplay = false;
            startupNotify = true;
            settings = {
              Keywords = "dosbox;dos";
            };
          };
          exogui = {
            name = "exogui";
            comment = "eXoDOS Launcher";
            exec = "exogui";
            icon = "distributor-logo-ms-dos";
            categories = [ "Game" ];
            noDisplay = false;
            startupNotify = true;
            settings = {
              Keywords = "exodos;dos";
            };
          };
          gog-galaxy = {
            name = "GOG Galaxy";
            comment = "Launch GOG Galaxy using Bottles.";
            exec = "bottles-cli run -p \"GOG Galaxy\" -b \"GOG Galaxy\"";
            icon = "/home/${username}/Games/Bottles/GOG-Galaxy/icons/GOG Galaxy.png";
            categories = [ "Game" ];
            noDisplay = false;
            startupNotify = true;
            actions = {
              "Configure" = { name = "Configure in Bottles"; exec = "bottles -b \"GOG Galaxy\""; };
            };
            settings = {
              StartupWMClass = "GOG Galaxy";
            };
          };
        };
      };
    };
  };
}
