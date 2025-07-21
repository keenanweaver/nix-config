{
  inputs,
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfg = config.gaming;
  p = with pkgs; {
    games = [
      ## Doom
      acc
      chocolate-doom
      crispy-doom
      darkradiant
      dhewm3
      doomrunner
      doomseeker
      dsda-doom
      gzdoom
      nugget-doom
      nyan-doom
      # odamex
      prboom-plus
      rbdoom-3-bfg
      sladeUnstable
      woof-doom
      zandronum
      ## Fallout
      fallout-ce
      fallout2-ce
      ## Freespace
      descent3
      dxx-rebirth
      knossosnet
      ## HOMM
      fheroes2
      vcmi
      ## Marathon
      alephone-marathon
      alephone-durandal
      alephone-infinity
      ## Morrowind
      inputs.openmw-nix.packages.${system}.openmw-dev
      #openmw
      ## Quake
      ironwail
      q2pro
      quake-injector
      uhexen2
      # trenchbroom
      ## Arma
      arma3-unix-launcher
      # (arma3-unix-launcher.override { buildDayZLauncher = true; })
      ## Duke
      eduke32
      raze
      rigel-engine
      ## Wolf
      bstone
      ecwolf
      etlegacy
      iortcw
      ## Other
      abuse
      am2rlauncher
      arx-libertatis # Arx Fatalis
      augustus # Caesar 3
      clonehero # Guitar Hero
      corsix-th # Theme Hospital
      isle-portable
      jazz2
      #katawa-shoujo-re-engineered
      openjk # Jedi Academy
      openloco
      inputs.chaotic.packages.${system}.openmohaa_git
      openomf
      openrct2
      (openttd.overrideAttrs {
        postPatch = ''
          substituteInPlace src/music/fluidsynth.cpp \
            --replace-fail "/usr/share/soundfonts/default.sf2" \
                           "${soundfont-generaluser}/share/soundfonts/GeneralUser-GS.sf2"
        '';
      })
      opentyrian
      (openxcom.overrideAttrs {
        pname = "openxcom-extended";
        version = "8.3.3";
        src = fetchFromGitHub {
          owner = "MeridianOXC";
          repo = "OpenXcom";
          rev = "41f48fc753ffcaba3fe9c537b62b64107e4f8bd4";
          hash = "sha256-QgHHjHri+SwWmQdPLuwn8gwsWLuP9amGHGTXqd/aRJs=";
        };
      })
      openxray # STALKER
      prismlauncher # MineCraft
      relive # Oddworld
      sdlpop # Prince of Persia
      sm64ex
      # inputs.nix-citizen.packages.${system}.star-citizen
      theforceengine # Dark Forces / Outlaws
      urbanterror
      vvvvvv
      wipeout-rewrite
      zelda64recomp
    ];
    tools = [
      ## Emulators
      _86Box-with-roms
      # archipelago
      nur.repos.bandithedoge.basiliskii-bin
      # bizhawk
      dosbox-staging
      hypseus-singe
      mednafen
      mednaffe
      mesen
      nuked-sc55
      # inputs.chaotic.packages.${system}.pcsx2_git
      inputs.chaotic.packages.${system}.shadps4_git
      nur.repos.bandithedoge.sheepshaver-bin
      # nur.repos.novel2430.vita3k
      xenia-canary
      ## Input
      joystickwake
      oversteer
      sc-controller
      ## Launchers & utils
      cartridges
      itch
      ## Modding
      hedgemodmanager
      limo
      nexusmods-app-unfree
      ## Other
      adwsteamgtk
      chiaki-ng
      flips
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-ugly
      gst_all_1.gstreamer
      gswatcher
      igir
      innoextract
      lgogdownloader
      parsec-bin
      tochd
      xlink-kai
      xvidcore
      ## Wine
      umu-launcher
      inputs.nix-gaming.packages.${system}.wine-tkg-ntsync
      winetricks
      ## One-and-dones
      /*
        inputs.aaru.packages.${system}.default
           inputs.nix-game-preservation.packages.${system}.dic-git-full
           glxinfo
           jpsxdec
           mame.tools
           mmv
           inputs.nix-game-preservation.packages.${system}.ndecrypt-git
           nsz
           inputs.nix-game-preservation.packages.${system}.sabretools-git
           inputs.nix-game-preservation.packages.${system}.unshieldsharp-git
           ps3-disc-dumper
           #(python3.withPackages (p: with p; [ lnkparse3 ]))
           inputs.nix-game-preservation.packages.${system}.redumper-git
           renderdoc
           vgmplay-libvgm
           vgmstream
           vgmtools
           vgmtrans
           vulkan-tools
      */
    ];
  };
in
{
  options = {
    gaming = {
      enable = lib.mkEnableOption "Enable Gaming module in NixOS";
    };
  };

  config = lib.mkIf cfg.enable {
    # Custom modules
    bottles.enable = true;
    cdemu.enable = true;
    coolercontrol.enable = true;
    fluidsynth.enable = true;
    gamemode.enable = false;
    gamescope.enable = true;
    gsr.enable = true;
    heroic.enable = true;
    lutris.enable = true;
    mangohud.enable = true;
    nero-umu.enable = true;
    nonfree.enable = true;
    obs.enable = true;
    steam.enable = true;
    sunshine.enable = true;
    vkbasalt.enable = true;
    zerotier.enable = true;

    boot = {
      extraModulePackages = with config.boot.kernelPackages; [
        gcadapter-oc-kmod
        zenergy
      ];
      kernelModules = [
        "gcadapter_oc"
        "ntsync"
        "zenergy"
      ];
      kernelPackages = lib.mkForce pkgs.linuxPackages_cachyos;
      kernelParams = [
        #"usbhid.mousepoll=8" # Reduce mouse polling rate to 125hz
        "gpu_sched.sched_policy=0" # https://gitlab.freedesktop.org/drm/amd/-/issues/2516#note_2119750
        "amdgpu.mcbp=0"
        "tsc=reliable"
        "clocksource=tsc"
        "mitigations=off"
        "preempt=full" # https://reddit.com/r/linux_gaming/comments/1g0g7i0/god_of_war_ragnarok_crackling_audio/lr8j475/?context=3#lr8j475
        "split_lock_detect=off"
      ];
      kernel = {
        sysctl = {
          "vm.max_map_count" = 2147483642;
          "vm.mmap_min_addr" = 0; # SheepShaver
          # https://github.com/CachyOS/CachyOS-Settings/blob/master/usr/lib/sysctl.d/99-cachyos-settings.conf
          "fs.file-max" = 2097152;
          "kernel.split_lock_mitigate" = 0;
          #"net.core.default_qdisc" = "cake";
          "net.core.netdev_max_backlog" = 4096;
          #"net.ipv4.tcp_congestion_control" = "bbr";
          "net.ipv4.tcp_fin_timeout" = 5;
          "vm.dirty_background_bytes" = 67108864;
          "vm.dirty_bytes" = 268435456;
          "vm.dirty_writeback_centisecs" = 1500;
          "vm.page-cluster" = 0;
          "vm.swappiness" = 100;
          "vm.vfs_cache_pressure" = 50;
        };
      };
    };

    chaotic.mesa-git.enable = true;

    environment = {
      etc = {
        logitech-g920 = {
          text = ''
            DefaultVendor=046d
            DefaultProduct=c261
            MessageEndpoint=01
            ResponseEndpoint=01
            TargetClass=0x03
            MessageContent="0f00010142"
          '';
          target = "usb_modeswitch.d/046d:c261";
        };
      };
    };

    hardware = {
      uinput.enable = true;
      xone.enable = true;
      xpadneo.enable = true;
    };

    nix.settings = {
      extra-substituters = [
        "https://just-one-more-cache.cachix.org/"
        "https://nix-gaming.cachix.org"
        "https://nix-citizen.cachix.org"
      ];
      extra-trusted-public-keys = [
        "just-one-more-cache.cachix.org-1:4nShcKEgcUEVlJqKFrgDwoGfqLnw5KPG4UDTV02jnr4="
        "nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    };

    programs = {
      _2ship2harkinian-git.enable = true;
      perfect-dark-git.enable = true;
      shipwright-git.enable = true;
      sm64coopdx.enable = true;
      spaghetti-kart-git.enable = true;
      starship-sf64.enable = true;
    };

    security = {
      pam = {
        loginLimits = [
          {
            domain = "*";
            item = "memlock";
            type = "-";
            value = "unlimited";
          }
          {
            domain = "*";
            item = "nofile";
            type = "-";
            value = "2097152";
          }
        ];
      };
    };

    services = {
      input-remapper = {
        enable = true;
      };
      hardware = {
        openrgb = {
          enable = true;
          package = pkgs.openrgb-with-all-plugins;
        };
      };
      scx = {
        enable = true;
        package = pkgs.scx.rustscheds;
        scheduler = "scx_lavd";
      };
      udev = {
        extraHwdb = builtins.concatStringsSep "\n" (
          with inputs;
          builtins.map builtins.readFile [
            "${simracing-hwdb}/90-cammus.hwdb"
            "${simracing-hwdb}/90-fanatec.hwdb"
            "${simracing-hwdb}/90-heusinkveld.hwdb"
            "${simracing-hwdb}/90-leo-bodnar.hwdb"
            "${simracing-hwdb}/90-oddor.hwdb"
            "${simracing-hwdb}/90-shh.hwdb"
            "${simracing-hwdb}/90-simagic.hwdb"
            "${simracing-hwdb}/90-simlab.hwdb"
            "${simracing-hwdb}/90-simsonn.hwdb"
            "${simracing-hwdb}/90-thrustmaster.hwdb"
            "${simracing-hwdb}/90-vrs.hwdb"
          ]
        );
        packages = with pkgs; [
          game-devices-udev-rules
          # https://github.com/CachyOS/CachyOS-Settings/blob/master/usr/lib/udev/rules.d/30-zram.rules
          (writeTextFile {
            name = "30-zram.rules";
            text = ''
              ACTION=="change", KERNEL=="zram0", ATTR{initstate}=="1", SYSCTL{vm.swappiness}="150", RUN+="${pkgs.bash}/bin/bash -c 'echo N > /sys/module/zswap/parameters/enabled'"
            '';
            destination = "/etc/udev/rules.d/30-zram.rules";
          })
          (writeTextFile {
            name = "40-logitech-g920.rules";
            text = ''
              ATTR{idVendor}=="046d", ATTR{idProduct}=="c261", RUN+="${usb-modeswitch}/bin/usb_modeswitch -c '/etc/usb_modeswitch.d/046d:c261'"
            '';
            destination = "/etc/udev/rules.d/40-logitech-g920.rules";
          })
          # https://github.com/CachyOS/CachyOS-Settings/blob/master/usr/lib/udev/rules.d/50-sata.rules
          (writeTextFile {
            name = "50-sata.rules";
            text = ''
              ACTION=="add", SUBSYSTEM=="scsi_host", KERNEL=="host*", ATTR{link_power_management_policy}="*", ATTR{link_power_management_policy}="max_performance"
            '';
            destination = "/etc/udev/rules.d/50-sata.rules";
          })
          # https://github.com/CachyOS/CachyOS-Settings/blob/master/usr/lib/udev/rules.d/60-ioschedulers.rules
          (writeTextFile {
            name = "60-ioschedulers.rules";
            text = ''
              # HDD
              ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
              # SSD
              ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
              # NVMe SSD
              ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="none"
            '';
            destination = "/etc/udev/rules.d/60-ioschedulers.rules";
          })
          # https://github.com/CachyOS/CachyOS-Settings/blob/master/usr/lib/udev/rules.d/69-hdparm.rules
          (writeTextFile {
            name = "69-hdparm.rules";
            text = ''
              ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", RUN+="${hdparm}/bin/hdparm -B 254 -S 0 /dev/%k"
            '';
            destination = "/etc/udev/rules.d/69-hdparm.rules";
          })
          (writeTextFile {
            name = "70-easysmx.rules";
            text = ''
              # EasySMX X05
              SUBSYSTEM=="usb", ATTR{idProduct}=="0091", ATTR{idVendor}=="2f24", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
            '';
            destination = "/etc/udev/rules.d/70-easysmx.rules";
          })
          (writeTextFile {
            name = "70-gamesir.rules";
            text = ''
              # GameSir Cyclone 2 Wireless Controller; USB
              ## Nintendo Switch
              SUBSYSTEM=="usb", ATTR{idProduct}=="2009", ATTR{idVendor}=="057e", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
              ## D-input/Sony
              SUBSYSTEM=="usb", ATTR{idProduct}=="09cc", ATTR{idVendor}=="054c", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
              ## X-input/XBOX
              SUBSYSTEM=="usb", ATTR{idProduct}=="1053", ATTR{idVendor}=="3537", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
              # GameSir Cyclone 2 Wireless Controller; 2.4GHz
              ## X-input/XBOX
              SUBSYSTEM=="usb", ATTR{idProduct}=="100b", ATTR{idVendor}=="3537", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
              # GameSir Cyclone 2 Wireless Controller; Bluetooth
              SUBSYSTEM=="input", ATTR{idProduct}=="8100", ATTR{idVendor}=="054c", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
            '';
            destination = "/etc/udev/rules.d/70-gamesir.rules";
          })
          (writeTextFile {
            name = "70-8bitdo.rules";
            text = ''
              # 8BitDo Arcade Stick; Bluetooth (X-mode)
              SUBSYSTEM=="input", ATTRS{name}=="8BitDo Arcade Stick", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
              # 8BitDo Ultimate 2.4G Wireless  Controller; USB/2.4Ghz
              ## X-mode
              SUBSYSTEM=="usb", ATTR{idProduct}=="3106", ATTR{idVendor}=="2dc8", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
              ## D-mode
              SUBSYSTEM=="usb", ATTR{idProduct}=="3012", ATTR{idVendor}=="2dc8", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
              # 8BitDo Ultimate 2C Wireless Controller; USB/2.4GHz
              SUBSYSTEM=="usb", ATTR{idProduct}=="310a", ATTR{idVendor}=="2dc8", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
            '';
            destination = "/etc/udev/rules.d/70-8bitdo.rules";
          })
          # https://github.com/starcitizen-lug/knowledge-base/wiki/Sticks,-Throttles,-&-Pedals
          (writeTextFile {
            name = "70-flight-stick.rules";
            text = ''
              # Virpil
              KERNEL=="hidraw*", ATTRS{idVendor}=="3344", ATTRS{idProduct}=="*", MODE="0660", TAG+="uaccess"
              ## Virpil Rudder Pedals
              ACTION=="add", SUBSYSTEM=="input", KERNEL=="event*", \
                ENV{ID_VENDOR_ID}=="3344", ENV{ID_MODEL_ID}=="01f8", \
                RUN+="${linuxConsoleTools}/bin/evdev-joystick --e %E{DEVNAME} --d 0"
              # VKB
              KERNEL=="hidraw*", ATTRS{idVendor}=="231d", ATTRS{idProduct}=="*", MODE="0660", TAG+="uaccess"
              ## VKB SEM
              ACTION=="add", SUBSYSTEM=="input", KERNEL=="event*", \
                ENV{ID_VENDOR_ID}=="231d", ENV{ID_MODEL_ID}=="2204", \
                RUN+="${linuxConsoleTools}/bin/evdev-joystick --e %E{DEVNAME} --d 0" 
              ## VKB Gunfighter L
              ACTION=="add", SUBSYSTEM=="input", KERNEL=="event*", \
                ENV{ID_VENDOR_ID}=="231d", ENV{ID_MODEL_ID}=="0127", \
                RUN+="${linuxConsoleTools}/bin/evdev-joystick --e %E{DEVNAME} --d 0" 
              ## VKB Gunfighter R
              ACTION=="add", SUBSYSTEM=="input", KERNEL=="event*", \
                ENV{ID_VENDOR_ID}=="231d", ENV{ID_MODEL_ID}=="0126", \
                RUN+="${linuxConsoleTools}/bin/evdev-joystick --e %E{DEVNAME} --d 0" 
            '';
            destination = "/etc/udev/rules.d/70-vkb.rules";
          })
          (writeTextFile {
            name = "ntsync-udev-rules";
            text = ''KERNEL=="ntsync", MODE="0660", TAG+="uaccess"'';
            destination = "/etc/udev/rules.d/70-ntsync.rules";
          })
          # https://wiki.archlinux.org/title/Gamepad#Motion_controls_taking_over_joypad_controls_and/or_causing_unintended_input_with_joypad_controls
          (writeTextFile {
            name = "51-disable-DS3-and-DS4-motion-controls.rules";
            text = ''
              SUBSYSTEM=="input", ATTRS{name}=="*Controller Motion Sensors", RUN+="${coreutils}/bin/rm %E{DEVNAME}", ENV{ID_INPUT_JOYSTICK}=""
            '';
            destination = "/etc/udev/rules.d/51-disable-DS3-and-DS4-motion-controls.rules";
          })
          # https://reddit.com/r/linux_gaming/comments/1fu4ggk/can_someone_explain_dualsense_to_me/lpwxv12/?context=3#lpwxv12
          (writeTextFile {
            name = "51-disable-dualsense-sound-and-vibration.rules";
            text = ''
              KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", MODE="0660", TAG+="uaccess"
              KERNEL=="hidraw*", KERNELS=="*054C:0CE6*", MODE="0660", TAG+="uaccess"
              ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", ENV{PULSE_IGNORE}="1", ENV{ACP_IGNORE}="1"
            '';
            destination = "/etc/udev/rules.d/51-disable-dualsense-sound-and-vibration.rules";
          })
        ];
      };
    };

    systemd = {
      extraConfig = ''
        DefaultLimitNOFILE=1048576
      '';
      tmpfiles = {
        rules = [
          # AMD V-Cache
          # https://wiki.cachyos.org/configuration/general_system_tweaks/#amd-3d-v-cache-optimizer
          "w /sys/bus/platform/drivers/amd_x3d_vcache/AMDI0101:00/amd_x3d_mode - - - - cache"
          # https://wiki.archlinux.org/title/Gaming#Make_the_changes_permanent
          /*
            "w /proc/sys/vm/compaction_proactiveness - - - - 0"
                   "w /proc/sys/vm/watermark_boost_factor - - - - 1"
                   "w /proc/sys/vm/min_free_kbytes - - - - 1048576"
                   "w /proc/sys/vm/watermark_scale_factor - - - - 500"
                   "w /sys/kernel/mm/lru_gen/enabled - - - - 5"
                   "w /proc/sys/vm/zone_reclaim_mode - - - - 0"
                   "w /proc/sys/vm/page_lock_unfairness - - - - 1"
                   "w /proc/sys/kernel/sched_child_runs_first - - - - 0"
                   "w /proc/sys/kernel/sched_autogroup_enabled - - - - 1"
                   "w /proc/sys/kernel/sched_cfs_bandwidth_slice_us - - - - 3000"
                   "w /sys/kernel/debug/sched/base_slice_ns  - - - - 3000000"
                   "w /sys/kernel/debug/sched/migration_cost_ns - - - - 500000"
                   "w /sys/kernel/debug/sched/nr_migrate - - - - 8"
          */
        ];
      };
    };

    home-manager.users.${username} =
      {
        inputs,
        config,
        ...
      }:
      {
        home = {
          file =
            let
              primaryscreen = "DP-1";
            in
            {
              desktop-entry-dxvk =
                let
                  configFile = pkgs.fetchurl {
                    url = "https://raw.githubusercontent.com/doitsujin/dxvk/master/dxvk.conf";
                    hash = "sha256-at2s/DZEwkzQT47rBOWRfd0jBu1pJuqsqyHslMbjVfk=";
                  };
                in
                {
                  enable = true;
                  text = ''
                    [Desktop Entry]
                    Comment=Create a new DXVK config from template
                    Icon=text-plain
                    Name=DXVK Config...
                    Type=Link
                    URL[$e]=file:${configFile}
                  '';
                  target = "${config.xdg.dataHome}/templates/dxvk.desktop";
                };
              desktop-entry-mangohud =
                let
                  configFile = pkgs.fetchurl {
                    url = "https://raw.githubusercontent.com/flightlessmango/MangoHud/master/data/MangoHud.conf";
                    hash = "sha256-v4HdqQtJBvPR19SNf+FxoV5wJ+0Ou/1UYAkIwskXIWc=";
                  };
                in
                {
                  enable = true;
                  text = ''
                    [Desktop Entry]
                    Comment=Create a new MangoHud config from template
                    Icon=io.github.flightlessmango.mangohud
                    Name=MangoHud Config...
                    Type=Link
                    URL[$e]=file:${configFile}
                  '';
                  target = "${config.xdg.dataHome}/templates/mangohud.desktop";
                };
              desktop-entry-vkBasalt =
                let
                  configFile = pkgs.fetchurl {
                    url = "https://raw.githubusercontent.com/DadSchoorse/vkBasalt/master/config/vkBasalt.conf";
                    hash = "sha256-IN/Kuc17EZfzRoo8af1XoBX2/48/bCdyOxw/Tl463Mg=";
                  };
                in
                {
                  enable = true;
                  text = ''
                    [Desktop Entry]
                    Comment=Create a new vkBasalt config from template
                    Icon=text-plain
                    Name=vkBasalt Config...
                    Type=Link
                    URL[$e]=file:${configFile}
                  '';
                  target = "${config.xdg.dataHome}/templates/vkBasalt.desktop";
                };
              roms-mt32-exodos = {
                enable = true;
                source = config.lib.file.mkOutOfStoreSymlink "${inputs.nonfree}/Music/roland";
                target = "${config.xdg.configHome}/dosbox/mt32-roms";
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
                # Import with: wine start regedit.exe /home/keenan/Games/wine-controller.reg
                enable = true;
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
                # Import with: wine start regedit.exe /home/keenan/Games/wine-mouse-acceleration.reg
                enable = true;
                text = ''
                  Windows Registry Editor Version 5.00

                  [HKEY_CURRENT_USER\Control Panel\Mouse]
                  "MouseSpeed"="0"
                  "MouseThreshold1"="0"
                  "MouseThreshold2"="0"
                '';
                target = "${config.home.homeDirectory}/Games/wine-mouse-acceleration.reg";
              };
            };
          packages =
            with pkgs;
            [
              (writeShellApplication {
                name = "script-exodos-nuked";
                runtimeEnv = {
                  EXODOS = "/mnt/crusader/Games/eXo/eXoDOS/eXo/eXoDOS";
                };
                runtimeInputs = [
                  fd
                  sd
                ];
                text = ''
                  fd -t file "run.bat" $EXODOS -x sd 'CONFIG -set "mididevice=fluidsynth"' 'CONFIG -set "mididevice=soundcanvas"' {}
                '';
              })
              (writeShellApplication {
                name = "script-game-stuff";
                runtimeEnv = {
                  DREAMM = "https://aarongiles.com/dreamm/releases/dreamm-3.0.3-linux-x64.tgz";
                  CONTY = "https://api.github.com/repos/Kron4ek/conty/releases/latest";
                  GAMES_DIR = "${config.home.homeDirectory}/Games";
                  LOCAL_BIN = "${config.home.homeDirectory}/.local/bin";
                };
                runtimeInputs = [
                  coreutils
                  curl
                  fd
                  jq
                  wget
                ];
                text = ''
                  ## DREAMM
                  wget -P "$GAMES_DIR"/games/dreamm $DREAMM
                  fd dreamm -e tgz "$GAMES_DIR"/games/dreamm -x tar xf {} -c "$GAMES_DIR"/games/dreamm
                  ## Conty
                  curl $CONTY | jq -r '.assets[] | select(.name | test("conty_lite.sh$")).browser_download_url' | xargs wget -P "$LOCAL_BIN"
                  chmod +x "$LOCAL_BIN"/conty_lite.sh
                '';
              })
              (writeShellApplication {
                name = "script-momw-update";
                runtimeEnv = {
                  MODLIST = "i-heart-vanilla-directors-cut";
                  MOMW_DIR = "${config.home.homeDirectory}/Games/openmw/momw-tools-pack-linux";
                };
                runtimeInputs = [
                  steam-run
                ];
                text = ''
                  pushd "$MOMW_DIR"
                  steam-run ./umo sync "$MODLIST"
                  steam-run ./umo install "$MODLIST"
                  steam-run ./momw-configurator-linux-amd64 config "$MODLIST" --run-navmeshtool --run-validator
                  steam-run ./umo vacuum
                  popd
                '';
              })
            ]
            ++ lib.flatten (lib.attrValues p);
          sessionVariables = {
            #SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS = "0";
          };
        };

        nixpkgs = {
          overlays = [
            inputs.umu.overlays.default
          ];
        };

        services = {
          flatpak = {
            overrides = {
              global = {
                Environment = {
                  FLATPAK_GL_DRIVERS = "mesa-git";
                  PULSE_SINK = "Game";
                };
              };
              "com.richwhitehouse.BigPEmu" = {
                Context = {
                  filesystems = [
                    "!home"
                  ];
                };
              };
              "dev.opengoal.OpenGOAL" = {
                Context = {
                  filesystems = [ "${config.home.homeDirectory}/Games/opengoal" ];
                };
              };
              "info.cemu.Cemu" = {
                Context = {
                  filesystems = [
                    "${config.home.homeDirectory}/Games/games/cemu"
                  ];
                };
              };
              "info.exult.exult" = {
                Context = {
                  filesystems = [
                    "${config.home.homeDirectory}/Music/soundfonts:ro"
                  ];
                };
              };
              "io.github.Faugus.faugus-launcher" = {
                Context = {
                  filesystems = [
                    "${config.home.homeDirectory}/Games/faugus"
                    "xdg-data/Steam"
                    "/mnt/crusader/Games"
                  ];
                };
              };
              "io.github.noxworld_dev.OpenNox" = {
                Context = {
                  filesystems = [
                    "!home"
                    "${config.home.homeDirectory}/Games/nox"
                  ];
                };
              };
              "io.github.ryubing.Ryujinx" = {
                Context = {
                  filesystems = [
                    "!home"
                    "${config.home.homeDirectory}/Games/games/switch"
                  ];
                };
              };
              "net.fsuae.FS-UAE" = {
                Context = {
                  filesystems = [
                    "!home"
                  ];
                };
              };
              "net.kuribo64.melonDS" = {
                Context = {
                  filesystems = [
                    "!home"
                    "/mnt/crusader/Games/Backups/Myrient/No-Intro"
                  ];
                };
              };
              "net.pcsx2.PCSX2" = {
                Context = {
                  filesystems = [
                    "host"
                    "/mnt/crusader/Games/Rom/CHD/Sony Playstation 2"
                  ];
                };
              };
              "net.rpcs3.RPCS3" = {
                Context = {
                  filesystems = [
                    "!home"
                    "${config.home.homeDirectory}/Games/games/rpcs3"
                  ];
                };
              };
              "org.azahar_emu.Azahar" = {
                Context = {
                  filesystems = [
                    "${config.home.homeDirectory}/Games/games/3ds"
                  ];
                };
              };
              "org.duckstation.DuckStation" = {
                Context = {
                  filesystems = [
                    "/mnt/crusader/Games/Rom/CHD/Sony Playstation"
                  ];
                };
              };
              "org.DolphinEmu.dolphin-emu" = {
                Context = {
                  filesystems = [
                    "/mnt/crusader/Games/Rom/CHD/Nintendo GameCube"
                  ];
                };
              };
              "org.easyrpg.player" = {
                Context = {
                  filesystems = [
                    "${config.home.homeDirectory}/Music/soundfonts:ro"
                    "${config.home.homeDirectory}/Games/games/rpg-maker"
                    "!home"
                    "!host"
                  ];
                  shared = "network"; # obs-gamecapture
                };
                Environment = {
                  RPG2K_RTP_PATH = "${config.home.homeDirectory}/Games/games/rpg-maker/RTP/2000";
                  RPG2K3_RTP_PATH = "${config.home.homeDirectory}/Games/games/rpg-maker/RTP/2003";
                };
              };
              "org.flycast.Flycast" = {
                Context = {
                  filesystems = [
                    "/mnt/crusader/Games/Rom/CHD/Sega Dreamcast"
                  ];
                };
              };
              "org.mamedev.MAME" = {
                Context = {
                  filesystems = [
                    "/mnt/crusader/Games/Rom/Other/MAME"
                    "!home"
                  ];
                };
              };
              "org.scummvm.ScummVM" = {
                Context = {
                  filesystems = [
                    "!home"
                    "${config.home.homeDirectory}/Music/roland:ro"
                    "${config.home.homeDirectory}/Music/soundfonts:ro"
                    "${config.home.homeDirectory}/Games/games/scummvm"
                  ];
                };
              };
            };
            packages = [
              "app.xemu.xemu"
              "com.fightcade.Fightcade"
              "com.fightcade.Fightcade.Wine"
              {
                appId = "org.freedesktop.Platform.GL.mesa-git/x86_64/24.08";
                origin = "flathub-beta";
              }
              {
                appId = "org.freedesktop.Platform.GL32.mesa-git/x86_64/24.08";
                origin = "flathub-beta";
              }
              "com.github.optyfr.JRomManager"
              "com.qzandronum.Q-Zandronum"
              "com.richwhitehouse.BigPEmu"
              "com.supermodel3.Supermodel"
              "dev.ares.ares"
              "dev.opengoal.OpenGOAL"
              "info.cemu.Cemu"
              "info.exult.exult"
              "io.github.Faugus.faugus-launcher"
              {
                appId = "io.github.hedge_dev.unleashedrecomp";
                bundle = "file://${config.home.homeDirectory}/Games/io.github.hedge_dev.unleashedrecomp.flatpak";
                sha256 = "13wca95yngfwl1y0c05y0b2w7aa8k3nkhvk46wsrxjvw3shb35im";
              }
              "io.github.noxworld_dev.OpenNox"
              "io.github.randovania.Randovania"
              "io.github.ryubing.Ryujinx"
              "io.github.santiagocezar.maniatic-launcher"
              "io.itch.tx00100xt.SeriousSamClassic-VK"
              "net.fsuae.FS-UAE"
              "net.kuribo64.melonDS"
              "net.nmlgc.rec98.sh01"
              {
                appId = "net.pcsx2.PCSX2";
                origin = "flathub-beta";
              }
              "net.rpcs3.RPCS3"
              "net.runelite.RuneLite"
              "net.sourceforge.uqm_mods.UQM-MegaMod"
              "org.azahar_emu.Azahar"
              "org.diasurgical.DevilutionX"
              "org.DolphinEmu.dolphin-emu"
              "org.duckstation.DuckStation"
              "org.easyrpg.player"
              "org.flycast.Flycast"
              "org.kartkrew.RingRacers"
              "org.mamedev.MAME"
              "org.openfodder.OpenFodder"
              "org.openjkdf2.OpenJKDF2"
              "org.pegasus_frontend.Pegasus"
              "org.ppsspp.PPSSPP"
              "org.scummvm.ScummVM"
              "org.sonic3air.Sonic3AIR"
              "org.srb2.SRB2"
              "vet.rsc.OpenRSC.Launcher"
            ];
          };
          ludusavi = {
            enable = true;
            backupNotification = true;
            settings = {
              backup = {
                path = "${config.home.homeDirectory}/Games/games/ludusavi";
                format = {
                  chosen = "zip";
                  zip.compression = "deflate";
                };
              };
              customGames = [
                {
                  name = "Blake Stone";
                  files = [
                    "${config.xdg.dataHome}/bibendovsky/bstone/*saved_game*"
                  ];
                }
                {
                  name = "Daikatana";
                  files = [
                    "${config.xdg.dataHome}/Daikatana/data/save_x64"
                  ];
                }
                {
                  name = "DevilutionX";
                  files = [
                    "${config.xdg.dataHome}/diasurgical/devilution/*.sv"
                  ];
                }
                {
                  name = "Dolphin-Emu";
                  files = [
                    "${config.xdg.dataHome}/dolphin-emu/StateSaves"
                    "${config.home.homeDirectory}/.var/app/org.DolphinEmu.dolphin-emu/data/dolphin-emu/StateSaves"
                  ];
                }
                {
                  name = "Doom";
                  files = [
                    "${config.xdg.configHome}/gzdoom/savegames"
                    "${config.xdg.dataHome}/cherry-doom/savegames"
                    "${config.xdg.dataHome}/chocolate-doom/savegames"
                    "${config.xdg.dataHome}/chocolate-heretic/savegames"
                    "${config.xdg.dataHome}/chocolate-hexen/savegames"
                    "${config.xdg.dataHome}/crispy-doom/savegames"
                    "${config.xdg.dataHome}/crispy-heretic/savegames"
                    "${config.xdg.dataHome}/crispy-hexen/savegames"
                    "${config.xdg.dataHome}/doom64ex-minus/*.dsg"
                    "${config.xdg.dataHome}/nugget-doom/savegames"
                    "${config.xdg.dataHome}/woof/savegames"
                  ];
                }
                {
                  name = "Doom 3";
                  files = [
                    "${config.xdg.dataHome}/dhewm3/base/savegames"
                    "${config.xdg.dataHome}/rbdoom3bfg/base/savegame"
                  ];
                }
                {
                  name = "Duckstation";
                  files = [
                    "${config.xdg.configHome}/duckstation/memcards"
                    "${config.xdg.configHome}/duckstation/savestates"
                    "${config.home.homeDirectory}/.var/app/org.duckstation.DuckStation/config/duckstation/memcards"
                    "${config.home.homeDirectory}/.var/app/org.duckstation.DuckStation/config/duckstation/savestates"
                  ];
                }
                {
                  name = "Duke3D";
                  files = [
                    "${config.xdg.configHome}/eduke32/*.esv"
                    "${config.xdg.configHome}/raze/savegames"
                  ];
                }
                {
                  name = "ECWolf";
                  files = [
                    "${config.xdg.dataHome}/ecwolf/savegames"
                  ];
                }
                {
                  name = "Exult";
                  files = [
                    "${config.home.homeDirectory}/.var/app/info.exult.exult/data/forgeofvirtue/save/*.sav"
                    "${config.home.homeDirectory}/.var/app/info.exult.exult/data/silverseed/save/*.sav"
                  ];
                }
                {
                  name = "OpenMW";
                  files = [
                    "${config.xdg.dataHome}/openmw/saves"
                  ];
                }
                {
                  name = "PCSX2";
                  files = [
                    "${config.xdg.configHome}/PCSX2/memcards"
                    "${config.xdg.configHome}/PCSX2/sstates"
                    "${config.home.homeDirectory}/.var/app/net.pcsx2.PCSX2/config/PCSX2/memcards"
                    "${config.home.homeDirectory}/.var/app/net.pcsx2.PCSX2/config/PCSX2/sstates"
                  ];
                }
                {
                  name = "ScummVM";
                  files = [
                    "${config.xdg.dataHome}/scummvm/saves"
                    "${config.home.homeDirectory}/.var/app/org.scummvm.ScummVM/data/scummvm/saves"
                  ];
                }
                {
                  name = "Ship of Harkinian";
                  files = [
                    "${config.xdg.dataHome}/soh/Save"
                  ];
                }
                {
                  name = "SM64EX";
                  files = [
                    "${config.xdg.dataHome}/sm64ex/sm64_save*"
                  ];
                }
                {
                  name = "The Force Engine";
                  files = [
                    "${config.xdg.dataHome}/TheForceEngine/Saves"
                  ];
                }
                {
                  name = "Wipeout";
                  files = [
                    "${config.xdg.dataHome}/phoboslab/wipeout/save*"
                  ];
                }
              ];
              restore = {
                path = "${config.home.homeDirectory}/Games/games/ludusavi";
              };
              roots = [
                {
                  path = "${config.xdg.configHome}/heroic";
                  store = "heroic";
                }
                {
                  path = "${config.home.homeDirectory}/Games/Heroic";
                  store = "heroic";
                }
                {
                  path = "${config.xdg.dataHome}/lutris";
                  store = "lutris";
                }
                {
                  path = "${config.home.homeDirectory}/Games/nero/Battle.net";
                  store = "otherWine";
                }
                {
                  path = "${config.home.homeDirectory}/Games/nero/GOG-Galaxy";
                  store = "otherWine";
                }
                {
                  path = "${config.home.homeDirectory}/Games/nero/itch.io";
                  store = "otherWine";
                }
                {
                  path = "${config.home.homeDirectory}/Games/nero/Uplay";
                  store = "otherWine";
                }
                {
                  path = "${config.xdg.dataHome}/Steam";
                  store = "steam";
                }
                {
                  path = "${config.home.homeDirectory}/Games/Steam";
                  store = "steam";
                }
                {
                  path = "${config.home.homeDirectory}/Games/games/SteamLibrary";
                  store = "steam";
                }
              ];
              theme = "dark";
            };
          };
          wayland-pipewire-idle-inhibit = {
            enable = true;
            settings = {
              verbosity = "WARN";
              media_minimum_duration = 5;
              idle_inhibitor = "d-bus";
              sink_whitelist = [
                { name = "Browser"; }
                { name = "Game"; }
                { name = "Music"; }
              ];
            };
          };
        };
        systemd.user.timers.ludusavi = lib.mkForce {
          Install.WantedBy = [ "timers.target" ];
          Timer = {
            OnBootSec = "2min";
            OnUnitActiveSec = "24h";
          };
        };
        xdg = {
          autostart.entries = with pkgs; [
            "${nuked-sc55}/share/applications/Nuked-SC55_silent.desktop"
          ];
          desktopEntries = {
            _86box = {
              name = "86Box (Win98SE)";
              exec = "86Box";
              icon = "net.86box.86Box";
              categories = [
                "Game"
                "Emulator"
              ];
              settings = {
                Path = "${config.home.homeDirectory}/Games/games/86box/win98se";
              };
            };
            gog-galaxy =
              let
                icon = pkgs.fetchurl {
                  url = "https://docs.gog.com/_assets/galaxy_icon_rgb.svg";
                  hash = "sha256-SpaFaSK05Uq534qPYV7s7/vzexZmMnpJiVtOsbCtjvg=";
                };
              in
              {
                name = "GOG Galaxy";
                comment = "Launch GOG Galaxy using nero-umu";
                exec = "nero-umu --prefix \"GOG Galaxy\" --shortcut \"GOG Galaxy\"";
                icon = "${icon}";
                categories = [ "Game" ];
                noDisplay = false;
                startupNotify = true;
                settings = {
                  StartupWMClass = "GOG Galaxy";
                };
              };
            itch = {
              name = "itch";
              comment = "Install and play itch.io games easily";
              exec = "env PULSE_SINK=Game obs-gamecapture mangohud itch";
              icon = "itch";
              categories = [ "Game" ];
            };
            quake-injector = {
              name = "Quake Injector";
              exec = "quake-injector";
              icon = "quake-injector";
              categories = [ "Game" ];
              settings = {
                Path = "${config.home.homeDirectory}/Games/quake/quake-1/injector";
              };
            };
          };
        };
      };
  };
}
