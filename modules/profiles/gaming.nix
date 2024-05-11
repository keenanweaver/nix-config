{ inputs, config, lib, pkgs, username, ... }:
let
  cfg = config.gaming;
  p = with pkgs; {
    games = [
      arx-libertatis # Arx Fatalis
      clonehero
      exult # Ultima VII
      openjk # Jedi Academy
      openloco # Locomotion
      openxray # STALKER
      wipeout-rewrite # Wipeout
      # Doom
      [
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
      ]
      # Fallout
      [
        fallout-ce
        fallout2-ce
      ]
      # Freespace
      [
        dxx-rebirth
        knossosnet
      ]
      # Marathon
      [
        alephone
        alephone-marathon
        alephone-durandal
        alephone-infinity
      ]
      # Quake
      [
        ironwail
        quake3e
        #trenchbroom
      ]
      # Star Citizen
      [
        inputs.nix-citizen.packages.${system}.star-citizen
        inputs.nix-citizen.packages.${system}.star-citizen-helper
      ]
      # Wolf3D
      [
        bstone
        ecwolf
      ]
    ];
    tools = [
      obs-studio-plugins.obs-vkcapture
      # Emulators 
      [
        #bizhawk
        #hypseus-singe
        #mesen
      ]
      # Input
      [
        joystickwake
        makima
        oversteer
        sc-controller
        xboxdrv
      ]
      # Graphics
      [
        glxinfo
        libstrangle
        vkbasalt
        vulkan-tools
      ]
      # Launchers 
      [
        bottles
        heroic
        lutris
      ]
      # Modding
      [
        r2modman # Lethal Company
      ]
      # Wine
      [
        winetricks
        wineWowPackages.stagingFull
      ]
      gst_all_1.gstreamer
      gst_all_1.gst-libav
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-ugly
      /*
      igir
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
  };
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
    sunshine.enable = true;
    timidity.enable = true;
    zerotier.enable = true;

    boot = {
      extraModulePackages = [
        config.boot.kernelPackages.gcadapter-oc-kmod
      ];
      kernelModules = [
        "gcadapter_oc"
      ];
      kernelParams = [
        "split_lock_detect=off"
      ];
      kernel = {
        sysctl = {
          "split_lock_mitigate" = 0; # https://reddit.com/r/linux_gaming/comments/1bgqfuk/god_of_war_poor_performance/kv8xsae/?context=3
          "vm.max_map_count" = 2147483642;
        };
      };
    };

    environment = {
      sessionVariables = {
        # https://reddit.com/r/linux_gaming/comments/1b9foom/workaround_for_cursor_movement_cutting_our_vrr_on/
        KWIN_DRM_DELAY_VRR_CURSOR_UPDATES = "1";
        KWIN_FORCE_SW_CURSOR = "1";
        #KWIN_DRM_DONT_FORCE_AMD_SW_CURSOR = "1";
        # https://invent.kde.org/plasma/kwin/-/merge_requests/927#note_586727
        KWIN_DRM_NO_AMS = "1"; # Input latency/tearing
        OBS_VKCAPTURE_QUIET = "1";
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
      #xone.enable = true;
      #xpadneo.enable = true;
    };

    # Trenchbroom
    /*     nixpkgs.config.permittedInsecurePackages = [
      "freeimage-unstable-2021-11-01"
    ]; */

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

    security = {
      pam = {
        loginLimits = [
          # https://scribe.rip/@a.b.t./here-are-some-possibly-useful-tweaks-for-steamos-on-the-steam-deck-fcb6b571b577
          # https://github.com/RPCS3/rpcs3/issues/9328#issuecomment-732390362
          # https://github.com/CachyOS/CachyOS-Settings/tree/master/etc/security/limits.d
          #{ domain = "*"; item = "nofile"; type = "-"; value = "unlimited"; }
          #{ domain = "*"; item = "memlock"; type = "-"; value = "unlimited"; } # RPCS3
          { domain = "*"; item = "nofile"; type = "hard"; value = "1048576"; }
        ];
      };
    };

    systemd = {
      extraConfig = ''
        DefaultLimitNOFILE=1048576
      '';
      tmpfiles = {
        rules = [
          # https://wiki.archlinux.org/title/Gaming#Make_the_changes_permanent
          "w /proc/sys/vm/compaction_proactiveness - - - - 0"
          "w /proc/sys/vm/min_free_kbytes - - - - 1048576"
          "w /sys/kernel/mm/lru_gen/enabled - - - - 5"
          "w /proc/sys/vm/zone_reclaim_mode - - - - 0"
          ## CS2
          #"w /sys/kernel/mm/transparent_hugepage/enabled - - - - never"
          #"w /sys/kernel/mm/transparent_hugepage/shmem_enabled - - - - never"
          #"w /sys/kernel/mm/transparent_hugepage/khugepaged/defrag - - - - 0"
          "w /proc/sys/vm/page_lock_unfairness - - - - 1"
          "w /proc/sys/kernel/sched_child_runs_first - - - - 0"
          "w /proc/sys/kernel/sched_autogroup_enabled - - - - 1"
          "w /proc/sys/kernel/sched_cfs_bandwidth_slice_us - - - - 500"
          "w /sys/kernel/debug/sched/latency_ns  - - - - 1000000"
          "w /sys/kernel/debug/sched/migration_cost_ns - - - - 500000"
          "w /sys/kernel/debug/sched/min_granularity_ns - - - - 500000"
          "w /sys/kernel/debug/sched/wakeup_granularity_ns  - - - - 0"
          "w /sys/kernel/debug/sched/nr_migrate - - - - 8"
          # https://github.com/CachyOS/CachyOS-Settings/blob/master/etc/tmpfiles.d/thp.conf
          "w! /sys/kernel/mm/transparent_hugepage/defrag - - - - defer+madvise"
        ];
      };
    };

    home-manager.users.${username} = { inputs, config, username, ... }: {
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
        # Use Bottles to manage Wine runners for Heroic and Lutris
        wine-links-heroic = {
          enable = true;
          recursive = true;
          source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.dataHome}/bottles/runners";
          target = "${config.xdg.configHome}/heroic/tools/wine";
        };
        wine-links-lutris = {
          enable = true;
          recursive = true;
          source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.dataHome}/bottles/runners";
          target = "${config.xdg.dataHome}/lutris/runners/wine";
        };
      };
      home.packages = lib.flatten (lib.attrValues p);
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
