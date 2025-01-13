{
  config,
  lib,
  pkgs,
  username,
  inputs,
  ...
}:
let
  cfg = config.gaming;
  p = with pkgs; {
    games = [
      ## Doom
      cherry-doom
      chocolate-doom
      crispy-doom
      # darkradiant
      dhewm3
      doom64ex-plus
      doomrunner
      doomseeker
      dsda-doom
      gzdoom
      nugget-doom
      # odamex
      prboom-plus
      rbdoom-3-bfg
      # slade
      woof-doom
      zandronum
      zandronum-server
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
      alephone
      alephone-marathon
      alephone-durandal
      alephone-infinity
      ## Quake
      ironwail
      q2pro
      quake-injector
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
      devilutionx # Diablo
      exult # Ultima VII
      ja2-stracciatella
      jazz2
      katawa-shoujo-re-engineered
      nur.repos.Rhys-T.lix-game # Lemmings clone
      openjk # Jedi Academy
      openloco # Locomotion
      openmw
      # opennox
      # openrct2
      openttd
      opentyrian
      openxray # STALKER
      prismlauncher # MineCraft
      relive # Oddworld
      ringracers
      runelite # RuneScape
      /*
        xh -o "$HOME/Games/mario-64/mario64.zip" -d https://myrient.erista.me/files/No-Intro/Nintendo%20-%20Nintendo%2064%20%28BigEndian%29/Super%20Mario%2064%20%28USA%29.zip
        ouch d "$HOME/Games/mario-64/mario64.zip" -y -d "$HOME/Games/mario-64"
        fd 'Mario' -e z64 $HOME/Games/mario-64 -x mv {} "$HOME/Games/mario-64/baserom.us.z64"
        nix-store --add-fixed sha256 /home/keenan/Games/mario-64/baserom.us.z64
      */
      sm64ex
      space-station-14-launcher
      srb2 # Sonic Robo Blast 2
      theforceengine # Dark Forces / Outlaws
      urbanterror
      wipeout-rewrite
      xivlauncher # FFXIV
      vvvvvv
    ];
    tools = [
      ## Emulators
      _86Box-with-roms
      # archipelago
      ares
      # bizhawk
      cemu
      dolphin-emu
      duckstation
      easyrpg-player
      flycast
      fsuae-launcher
      hypseus-singe
      lime3ds
      mame
      mesen
      nuked-sc55
      pcsx2
      pegasus-frontend
      ppsspp
      (retroarch.withCores (
        cores: with cores; [
          beetle-saturn
          blastem
          mgba
        ]
      ))
      rpcs3
      scummvm
      supermodel
      xemu
      ## Input
      joystickwake
      # makima
      oversteer
      sc-controller
      # xboxdrv
      ## Launchers & utils
      cartridges
      limo
      #inputs.umu.packages.${pkgs.system}.umu
      ## Modding
      nexusmods-app-unfree
      owmods-gui
      r2modman
      ## Other
      inputs.aaru.packages.${pkgs.system}.default
      adwsteamgtk
      chiaki-ng
      inputs.nix-game-preservation.packages.${pkgs.system}.discimagecreator
      ffmpeg
      gst_all_1.gstreamer
      gst_all_1.gstreamermm
      gst_all_1.gst-plugins-rs
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-libav
      gst_all_1.gst-vaapi
      gswatcher
      mpg123
      inputs.nix-game-preservation.packages.${pkgs.system}.ndecrypt
      parsec-bin
      inputs.nix-game-preservation.packages.${pkgs.system}.redumper
      x264
      x265
      xvidcore
      ## Wine
      inputs.nix-gaming.packages.${pkgs.system}.wine-discord-ipc-bridge
      inputs.nix-gaming.packages.${pkgs.system}.wine-tkg
      winetricks
      # wineWowPackages.stagingFull
      ## One-and-dones
      /*
        glxinfo
           igir
           innoextract
           jpsxdec
           lgogdownloader 
           mame.tools
           mmv
           nsz
           oxyromon
           ps3-disc-dumper
           renderdoc
           vgmplay-libvgm
           vgmstream
           vgmtools
           vulkan-tools
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
    bottles.enable = true;
    cdemu.enable = true;
    coolercontrol.enable = true;
    fluidsynth.enable = true;
    gamemode.enable = true;
    gamescope.enable = true;
    gsr.enable = true;
    heroic.enable = true;
    lact.enable = true;
    lutris.enable = true;
    mangohud.enable = true;
    nonfree.enable = true;
    obs.enable = true;
    steam.enable = true;
    sunshine.enable = true;
    vkbasalt.enable = true;
    zerotier.enable = true;

    boot = {
      extraModprobeConfig = ''
        options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
      '';
      extraModulePackages = with config.boot.kernelPackages; [
        gcadapter-oc-kmod
        v4l2loopback
      ];
      initrd = {
        kernelModules = [
          "hid-nintendo"
          "snd-seq"
          "snd-rawmidi"
        ];
      };
      kernelModules = [
        "gcadapter_oc"
      ];
      kernelParams = [
        # "usbhid.mousepoll=8" # Reduce mouse polling rate to 125hz
        "gpu_sched.sched_policy=0" # https://gitlab.freedesktop.org/drm/amd/-/issues/2516#note_2119750
        "amdgpu.mcbp=0"
        "tsc=reliable"
        "clocksource=tsc"
        "preempt=full" # https://reddit.com/r/linux_gaming/comments/1g0g7i0/god_of_war_ragnarok_crackling_audio/lr8j475/?context=3#lr8j475
      ];
      kernel = {
        sysctl = {
          # "kernel.sched_cfs_bandwidth_slice_us" = 3000;
          # "net.ipv4.tcp_fin_timeout" = 5;
          "vm.max_map_count" = 2147483642;
          "vm.mmap_min_addr" = 0; # SheepShaver
          # https://github.com/CachyOS/CachyOS-Settings/blob/master/usr/lib/sysctl.d/99-cachyos-settings.conf
          "fs.file-max" = 2097152;
          "fs.inotify.max_user_watches" = 524288;
          "net.core.netdev_max_backlog" = 16384;
          "net.core.somaxconn" = 8192;
          "net.ipv4.tcp_slow_start_after_idle" = 0;
        };
      };
    };

    environment = {
      sessionVariables = {
        # https://reddit.com/r/linux_gaming/comments/1c2ey6u/vrr_newbie_questions_plasma_6_wayland_amd/kzasm0j/?context=3#kzasm0j
        KWIN_DRM_DELAY_VRR_CURSOR_UPDATES = "1";
        KWIN_FORCE_SW_CURSOR = "1";
      };
    };

    hardware = {
      new-lg4ff.enable = true;
      uinput.enable = true;
      # xone.enable = true;
      # xpadneo.enable = true;
    };

    nix.settings = {
      extra-substituters = [
        "https://nix-gaming.cachix.org"
        "https://nix-citizen.cachix.org"
      ];
      extra-trusted-public-keys = [
        "nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    };

    nixpkgs.config.permittedInsecurePackages = [
      # "freeimage-unstable-2021-11-01" # Trenchbroom / SLADE
    ];

    networking = {
      firewall = {
        # Outer Wilds Quantum Space Buddies KCP
        /*
          allowedTCPPorts = [ 7777 ];
               allowedUDPPorts = [ 7777 ];
        */
      };
    };

    services = {
      hardware = {
        openrgb = {
          enable = true;
          package = pkgs.openrgb-with-all-plugins;
        };
      };
      # joycond.enable = true;
      # ratbagd.enable = true;
      scx = {
        enable = true;
        package = pkgs.scx.rustscheds;
        scheduler = "scx_rusty";
      };
      udev = {
        extraRules = ''
          # https://wiki.archlinux.org/title/Improving_performance#Changing_I/O_scheduler
          # HDD
          ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"

          # SSD
          ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="bfq"

          # NVMe SSD
          ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="none"
        '';
        packages = with pkgs; [
          game-devices-udev-rules
          # https://wiki.archlinux.org/title/Gamepad#Motion_controls_taking_over_joypad_controls_and/or_causing_unintended_input_with_joypad_controls
          (writeTextFile {
            name = "51-disable-DS3-and-DS4-motion-controls.rules";
            text = ''
              SUBSYSTEM=="input", ATTRS{name}=="*Controller Motion Sensors", RUN+="${pkgs.coreutils}/bin/rm %E{DEVNAME}", ENV{ID_INPUT_JOYSTICK}=""
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

    security = {
      pam = {
        loginLimits = [
          {
            domain = "*";
            item = "memlock";
            type = "hard";
            value = "unlimited";
          }
          {
            domain = "*";
            item = "memlock";
            type = "soft";
            value = "unlimited";
          }
          {
            domain = "*";
            item = "nofile";
            type = "hard";
            value = "1048576";
          }
          {
            domain = "*";
            item = "nofile";
            type = "soft";
            value = "16777216";
          }
        ];
      };
    };

    services = {
      input-remapper = {
        enable = true;
        # enableUdevRules = true;
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
        imports = [
          ../apps/ludusavi
        ];
        home.file = {
          autostart-nuked = {
            enable = true;
            text = ''
              [Desktop Entry]
              Exec=nuked-sc55 -i
              Name=nuked-sc55
              Terminal=false
              Type=Application
            '';
            target = "${config.xdg.configHome}/autostart/nuked.desktop";
            executable = true;
          };
          desktop-entry-86box = {
            enable = true;
            text = ''
              [Desktop Entry]
              Categories=System;Emulator;
              Comment=An emulator for classic IBM PC clones
              Exec=86Box
              GenericName=Classic PC emulator
              Icon=net.86box.86Box
              Name=86Box
              NoDisplay=false
              Path=${config.home.homeDirectory}/Games/games/86box/win98se/
              StartupNotify=true
              Terminal=false
              TerminalOptions=
              Type=Application
              X-KDE-SubstituteUID=false
              X-KDE-Username=
            '';
            target = "${config.xdg.dataHome}/applications/net.86box.86Box.desktop";
          };
          desktop-entry-dxvk =
            let
              configFile = pkgs.fetchurl {
                url = "https://raw.githubusercontent.com/doitsujin/dxvk/master/dxvk.conf";
                hash = "sha256-gUxx6oIUg7uCVQff02vgfoG7qBY0IBNMah8BR1hjN0w=";
              };
            in
            {
              enable = true;
              text = ''
                [Desktop Entry]
                Comment=Create a new DXVK config from template
                Icon=text-x-makefile
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
                hash = "sha256-BcZt5Ma5injmHmlT8BkgXVrEM8yAn6N/wQamm4x1m60=";
              };
            in
            {
              enable = true;
              text = ''
                [Desktop Entry]
                Comment=Create a new MangoHud config from template
                Icon=text-x-makefile
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
                Icon=text-x-makefile
                Name=vkBasalt Config...
                Type=Link
                URL[$e]=file:${configFile}
              '';
              target = "${config.xdg.dataHome}/templates/vkBasalt.desktop";
            };
          desktop-entry-obs-flatpak = {
            enable = true;
            text = ''
              [Desktop Entry]
              Categories=AudioVideo;Recorder;
              Comment[en_US]=Free and Open Source Streaming/Recording Software
              Comment=Free and Open Source Streaming/Recording Software
              Exec=env QT_QPA_PLATFORM=xcb GDK_BACKEND=x11 flatpak run --branch=stable --arch=x86_64 --command=obs com.obsproject.Studio --disable-shutdown-check
              GenericName[en_US]=Streaming/Recording Software
              GenericName=Streaming/Recording Software
              Icon=com.obsproject.Studio
              MimeType=
              Name[en_US]=OBS Studio
              Name=OBS Studio
              NoDisplay=false
              Path=
              StartupNotify=true
              StartupWMClass=obs
              Terminal=false
              TerminalOptions=
              Type=Application
              Version=1.0
              X-Flatpak=com.obsproject.Studio
              X-KDE-SubstituteUID=false
              X-KDE-Username=
            '';
            target = "${config.xdg.dataHome}/applications/com.obsproject.Studio.desktop";
          };
          desktop-entry-quakeinjector = {
            enable = true;
            text = ''
              [Desktop Entry]
              Categories=Game
              Comment=Download, install and play quake singleplayer maps from the quaddicted.com archive
              Exec=quake-injector
              Icon=quake-injector
              Name=Quake Injector
              NoDisplay=false
              Path=${config.home.homeDirectory}/Games/quake/quake-1/injector/
              StartupNotify=true
              Terminal=false
              TerminalOptions=
              Type=Application
              Version=1.4
              X-KDE-SubstituteUID=false
              X-KDE-Username=
            '';
            target = "${config.xdg.dataHome}/applications/quake-injector.desktop";
          };
          roms-mt32-exodos = {
            enable = true;
            source = config.lib.file.mkOutOfStoreSymlink "${inputs.nonfree}/Music/roland";
            target = "${config.xdg.configHome}/dosbox/mt32-roms";
          };
          wine-controller-proton = {
            # https://selfmadepenguin.wordpress.com/2024/02/14/how-i-solved-my-gamecontroller-problems/
            # Import with: wine start regedit.exe /home/keenan/.wine/controller-proton.reg
            enable = true;
            text = ''
              Windows Registry Editor Version 5.00

              [HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\winebus]
              "DisableHidraw"=dword:00000001
              "Enable SDL"=dword:00000001
            '';
            target = "${config.home.homeDirectory}/.wine/controller-proton.reg";
          };
          wine-mouse-acceleration = {
            # https://reddit.com/r/linux_gaming/comments/1hs1685/windows_mouse_acceleration_seems_to_be_enabled_in/
            # Import with: wine start regedit.exe /home/keenan/.wine/mouse-acceleration-proton.reg
            enable = true;
            text = ''
              Windows Registry Editor Version 5.00

              [HKEY_CURRENT_USER\Control Panel\Mouse]
              "MouseSpeed"="0"
              "MouseThreshold1"="0"
              "MouseThreshold2"="0"
            '';
            target = "${config.home.homeDirectory}/.wine/mouse-acceleration-proton.reg";
          };
        };
        home.packages =
          with pkgs;
          [
            (writeShellApplication {
              name = "script-game-stuff";
              runtimeInputs = [
                coreutils
                findutils
                jq
                sd
                (steamtinkerlaunch.overrideAttrs (o: {
                  src = inputs.steamtinkerlaunch-master;
                }))
                xh
              ];
              text =
                let
                  dreamm = "https://aarongiles.com/dreamm/releases/dreamm-3.0.3-linux-x64.tgz";
                in
                ''
                  ## SteamTinkerLaunch https://gist.github.com/jakehamilton/632edeb9d170a2aedc9984a0363523d3
                  steamtinkerlaunch compat add
                  sd 'YAD="(.*?)"' 'YAD="/etc/profiles/per-user/${username}/bin/yad"' ${config.xdg.configHome}/steamtinkerlaunch/global.conf
                  sd 'STLEDITOR="(.*?)"' 'STLEDITOR="/etc/profiles/per-user/${username}/bin/kate"' ${config.xdg.configHome}/steamtinkerlaunch/global.conf
                  sd 'SKIPINTDEPCHECK="(.*?)"' 'SKIPINTDEPCHECK="1"' ${config.xdg.configHome}/steamtinkerlaunch/global.conf
                  sd 'USEGAMEMODERUN="(.*?)"' 'USEGAMEMODERUN="1"' ${config.xdg.configHome}/steamtinkerlaunch/default_template.conf
                  sd 'USEOBSCAP="(.*?)"' 'USEOBSCAP="1"' ${config.xdg.configHome}/steamtinkerlaunch/default_template.conf
                  sd 'USEMANGOHUD="(.*?)"' 'USEMANGOHUD="1"' ${config.xdg.configHome}/steamtinkerlaunch/default_template.conf
                  sd 'MAHUDLSYM="(.*?)"' 'MAHUDLSYM="1"' ${config.xdg.configHome}/steamtinkerlaunch/default_template.conf
                  sd 'USERAYTRACING="(.*?)"' 'USERAYTRACING="1"' ${config.xdg.configHome}/steamtinkerlaunch/default_template.conf
                  sd 'USEPROTON="(.*?)"' 'USEPROTON="Proton-GE"' ${config.xdg.configHome}/steamtinkerlaunch/default_template.conf
                  sd 'GAMESCOPE_ARGS="(.*?)"' 'GAMESCOPE_ARGS="-w 2560 -h 1440 -W 2560 -H 1440 -f --force-grab-cursor --"' ${config.xdg.configHome}/steamtinkerlaunch/default_template.conf
                  echo 'PULSE_SINK=Game' > ${config.xdg.configHome}/steamtinkerlaunch/gamecfgs/customvars/global-custom-vars.conf
                  fd . '${config.xdg.configHome}/steamtinkerlaunch/gamecfgs/id' -e .conf -x rm {}
                  ## DREAMM
                  xh get -d -o ${config.home.homeDirectory}/Games/games/dreamm.tgz ${dreamm}
                  fd dreamm -e tgz ${config.home.homeDirectory}/Games/games -x ouch d {} -d ${config.home.homeDirectory}/Games/games
                  ## SheepShaver
                  xh https://api.github.com/repos/Korkman/macemu-appimage-builder/releases/latest | jq -r '.assets[] | select(.name | test("x86_64.AppImage$")).browser_download_url' | xargs xh get -d -o ${config.home.homeDirectory}/.local/bin/sheepshaver.appimage
                  ## MoonDeck Buddy
                  xh https://api.github.com/repos/FrogTheFrog/moondeck-buddy/releases/latest | jq -r '.assets[] | select(.name | test("x86_64.AppImage$")).browser_download_url' | xargs xh get -d -o ${config.home.homeDirectory}/.local/bin/moondeckbuddy.appimage
                  ## Conty
                  xh https://api.github.com/repos/Kron4ek/conty/releases/latest | jq -r '.assets[] | select(.name | test("conty_lite.sh$")).browser_download_url' | xargs xh get -d -o ${config.home.homeDirectory}/.local/bin/conty_lite.sh
                  chmod +x ${config.home.homeDirectory}/.local/bin/conty_lite.sh
                '';
            })
            # https://www.resetera.com/threads/linux-steamos-ot-its-a-linux-system%E2%80%A6-i-know-this.557173/page-36#post-130996374
            (writeShellApplication {
              name = "script-wine-cpu-topology";
              runtimeInputs = [
                coreutils
              ];
              text = ''
                if [[ -z $1 || $1 -gt $(nproc) || $1 -lt 1 ]]; then
                  args=$(nproc)
                else
                  args=$1
                fi

                grep "" /sys/devices/system/cpu/cpu*/cpufreq/amd_pstate_prefcore_ranking | sort -n -r -k2 -t: | head -n "$args" | awk -F'[u/]' -v ORS="," '{ print $8}' | head -c-1 | awk -v args="$args" '{printf "WINE_CPU_TOPOLOGY=%s:%s taskset -c %s\n",args, $0, $0}'
              '';
            })
          ]
          ++ lib.flatten (lib.attrValues p);
        home.sessionVariables = {
          RPG2K_RTP_PATH = "${config.xdg.dataHome}/games/rpg-maker/RTP/2000";
          RPG2K3_RTP_PATH = "${config.xdg.dataHome}/games/rpg-maker/RTP/2003";
          # https://gitlab.com/OpenMW/openmw/-/issues/6185
          OSG_VERTEX_BUFFER_HINT = "VERTEX_BUFFER_OBJECT";
        };
        services = {
          flatpak = {
            overrides = {
              "dev.opengoal.OpenGOAL" = {
                Context = {
                  filesystems = [ "${config.home.homeDirectory}/Games/opengoal" ];
                };
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
              "io.github.noxworld_dev.OpenNox" = {
                Context = {
                  filesystems = [
                    "!home"
                    "${config.home.homeDirectory}/Games/nox"
                  ];
                };
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
              "io.openrct2.OpenRCT2" = {
                Context = {
                  filesystems = [ "${config.home.homeDirectory}/Games/rollercoaster-tycoon" ];
                };
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
              "org.ryujinx.Ryujinx" = {
                Context = {
                  filesystems = [
                    "${config.home.homeDirectory}/Games"
                    "/mnt/crusader/Games/Rom/Other/Switch"
                    "xdg-data/games"
                    "!home"
                  ];
                };
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
            };
            packages = [
              "com.fightcade.Fightcade"
              "com.fightcade.Fightcade.Wine"
              "com.github.optyfr.JRomManager"
              "com.obsproject.Studio.Plugin.InputOverlay"
              "com.obsproject.Studio.Plugin.OBSVkCapture"
              "com.qzandronum.Q-Zandronum"
              "com.richwhitehouse.BigPEmu"
              "dev.opengoal.OpenGOAL"
              "io.github.noxworld_dev.OpenNox"
              "io.github.santiagocezar.maniatic-launcher"
              "io.itch.tx00100xt.SeriousSamClassic-VK"
              "io.openrct2.OpenRCT2"
              "net.sourceforge.uqm_mods.UQM-MegaMod"
              "org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/24.08"
              "org.freedesktop.Platform.VulkanLayer.OBSVkCapture/x86_64/24.08"
              "org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/24.08"
              "org.freedesktop.Platform.VulkanLayer.vkBasalt/x86_64/24.08"
              "org.openfodder.OpenFodder"
              "org.openjkdf2.OpenJKDF2"
              "org.ryujinx.Ryujinx"
              "org.sonic3air.Sonic3AIR"
              "vet.rsc.OpenRSC.Launcher"
            ];
          };
          ludusavi = {
            enable = true;
            backupNotification = true;
            /*
              schedule = {
                         frequency = "10:00";
                         onBoot.enable = true;
                       };
                       service = {
                         notification.enable = true;
                       };
            */
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
                  name = "Doom";
                  files = [
                    "${config.xdg.configHome}/gzdoom/savegames"
                    "${config.xdg.dataHome}/cherry-doom/savegames"
                    "${config.xdg.dataHome}/nugget-doom/savegames"
                    "${config.xdg.dataHome}/woof/savegames"
                  ];
                }
                {
                  name = "OpenMW";
                  files = [
                    "${config.xdg.dataHome}/openmw/saves"
                  ];
                }
                {
                  name = "ScummVM";
                  files = [
                    "${config.xdg.dataHome}/scummvm/saves"
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
                  path = "${config.home.homeDirectory}/Games/Bottles/GOG-Galaxy";
                  store = "otherWine";
                }
                {
                  path = "${config.home.homeDirectory}/Games/Bottles/itch.io";
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
                # { name = "Game"; } # nuked-sc55 & fluidsynth will interfere with screensaver
                { name = "Music"; }
              ];
            };
          };
        };
        xdg = {
          desktopEntries = {
            gog-galaxy =
              let
                galaxyIcon = pkgs.fetchurl {
                  url = "https://docs.gog.com/_assets/galaxy_icon_rgb.svg";
                  hash = "sha256-SpaFaSK05Uq534qPYV7s7/vzexZmMnpJiVtOsbCtjvg=";
                };
              in
              {
                name = "GOG Galaxy";
                comment = "Launch GOG Galaxy using Bottles.";
                exec = "flatpak run --command=bottles-cli run -p \"GOG Galaxy\" -b \"GOG Galaxy\" -- %u";
                icon = "${galaxyIcon}";
                categories = [ "Game" ];
                noDisplay = false;
                startupNotify = true;
                settings = {
                  StartupWMClass = "GOG Galaxy";
                };
              };
          };
        };
      };
  };
}
