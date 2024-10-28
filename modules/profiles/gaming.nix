{
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
      cherry-doom
      # chocolate-doom
      crispy-doom
      doom64ex-plus
      doomrunner
      doomseeker
      dsda-doom
      gzdoom
      nugget-doom
      prboom-plus
      # rbdoom-3-bfg
      woof-doom
      zandronum
      zandronum-server
      ## Fallout
      fallout-ce
      fallout2-ce
      ## Freespace
      dxx-rebirth
      knossosnet
      ## Marathon
      /*
        alephone
           alephone-marathon
           alephone-durandal
           alephone-infinity
      */
      ## N64
      /*
        _2s2h
           shipwright
           zelda64recomp
      */
      ## Quake
      /*
        (ioquake3.overrideAttrs (attrs: {
               version = "unstable-2024-05-20";
               src = fetchFromGitHub {
                 owner = "ioquake";
                 repo = "ioq3";
                 rev = "1fc83e4845b53a9b259f5980468c8db15fce8de7";
                 hash = "sha256-qnIyNXPeSu/vJfURw7BG41qosAoKGS6NZR9cCb/9Cxw=";
               };
             }))
      */
      ironwail
      # trenchbroom
      ## Arma
      arma3-unix-launcher
      # (arma3-unix-launcher.override { buildDayZLauncher = true; })
      ## Duke3D
      eduke32
      raze
      rigel-engine
      ## Star Citizen
      # inputs.nix-citizen.packages.${system}.star-citizen
      # inputs.nix-citizen.packages.${system}.star-citizen-helper
      ## Wolf
      bstone
      ecwolf
      iortcw
      ## Other
      arx-libertatis # Arx Fatalis
      clonehero # Guitar Hero
      exult # Ultima VII
      # inputs.ow-mod-man.packages.${system}.owmods-cli
      # inputs.ow-mod-man.packages.${system}.owmods-gui
      openjk # Jedi Academy
      openloco # Locomotion
      # openxray # STALKER
      #relive # Oddworld
      wipeout-rewrite # Wipeout
      vvvvvv
    ];
    tools = [
      ## Emulators 
      # archipelago
      # bizhawk
      # hypseus-singe
      # mesen
      nuked-sc55
      ## Input
      joystickwake
      # makima
      oversteer
      sc-controller
      xboxdrv
      ## Graphics
      glxinfo
      libstrangle
      vulkan-tools
      ## Launchers & utils
      # bottles
      # cartridges
      # heroic
      # lutris
      ## Modding
      # nexusmods-app-unfree
      r2modman
      ## Wine
      # inputs.nix-gaming.packages.${pkgs.system}.wine-discord-ipc-bridge
      winetricks
      wineWowPackages.stagingFull
      ## One-and-dones
      /*
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
    coolercontrol.enable = true;
    corectrl.enable = false;
    fluidsynth.enable = true;
    gamemode.enable = true;
    gamescope.enable = true;
    gsr.enable = true;
    lact.enable = true;
    mangohud.enable = true;
    nonfree.enable = true;
    obs.enable = true;
    solaar.enable = false;
    steam.enable = true;
    sunshine.enable = true;
    timidity.enable = false;
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
        "split_lock_detect=off"
        "usbhid.mousepoll=8" # Reduce mouse polling rate to 125hz
        "gpu_sched.sched_policy=0" # https://gitlab.freedesktop.org/drm/amd/-/issues/2516#note_2119750
        "amdgpu.mcbp=0"
      ];
      kernel = {
        sysctl = {
          "kernel.split_lock_mitigate" = 0; # https://reddit.com/r/linux_gaming/comments/1bgqfuk/god_of_war_poor_performance/kv8xsae/?context=3
          "vm.max_map_count" = 2147483642;
          "vm.mmap_min_addr" = 0; # SheepShaver
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
      #xone.enable = true;
      #xpadneo.enable = true;
    };

    # Trenchbroom
    /*
      nixpkgs.config.permittedInsecurePackages = [
        "freeimage-unstable-2021-11-01"
      ];
    */

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
      #joycond.enable = true;
      #ratbagd.enable = true;
      udev = {
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
          # https://scribe.rip/@a.b.t./here-are-some-possibly-useful-tweaks-for-steamos-on-the-steam-deck-fcb6b571b577
          # https://github.com/RPCS3/rpcs3/issues/9328#issuecomment-732390362
          # https://github.com/CachyOS/CachyOS-Settings/tree/master/etc/security/limits.d
          #{ domain = "*"; item = "nofile"; type = "-"; value = "unlimited"; }
          # RPCS3
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
        ];
      };
    };

    services = {
      input-remapper = {
        enable = true;
        #enableUdevRules = true;
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

    home-manager.users.${username} =
      {
        inputs,
        config,
        ...
      }:
      {
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
          desktop-entry-dxvk =
            let
              dxvkConfig = pkgs.fetchurl {
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
                URL[$e]=file:${dxvkConfig}
              '';
              target = "${config.xdg.dataHome}/templates/dxvk.desktop";
            };
          desktop-entry-mangohud =
            let
              mangohudConfig = pkgs.fetchurl {
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
                URL[$e]=file:${mangohudConfig}
              '';
              target = "${config.xdg.dataHome}/templates/mangohud.desktop";
            };
          desktop-entry-vkBasalt =
            let
              vkBasaltConfig = pkgs.fetchurl {
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
                URL[$e]=file:${vkBasaltConfig}
              '';
              target = "${config.xdg.dataHome}/templates/vkBasalt.desktop";
            };

          roms-mt32-exodos = {
            enable = true;
            recursive = true;
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
          wine-links-protonge-bottles = {
            enable = true;
            source = config.lib.file.mkOutOfStoreSymlink "${pkgs.proton-ge-custom}/bin";
            target = "${config.home.homeDirectory}/.var/app/com.usebottles.bottles/data/bottles/runners/proton-ge-custom";
          };
          wine-links-protonge-heroic = {
            enable = true;
            source = config.lib.file.mkOutOfStoreSymlink "${pkgs.proton-ge-custom}/bin";
            target = "${config.home.homeDirectory}/.var/app/com.heroicgameslauncher.hgl/config/heroic/tools/proton/proton-ge-custom";
          };
          wine-links-protonge-lutris = {
            enable = true;
            source = config.lib.file.mkOutOfStoreSymlink "${pkgs.proton-ge-custom}/bin";
            target = "${config.home.homeDirectory}/.var/app/net.lutris.Lutris/data/lutris/runners/wine/proton-ge-custom";
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
              text = ''
                ## SteamTinkerLaunch https://gist.github.com/jakehamilton/632edeb9d170a2aedc9984a0363523d3
                steamtinkerlaunch compat add
                ## DREAMM
                xh get -d -o ${config.home.homeDirectory}/Games/dreamm.tgz https://aarongiles.com/dreamm/releases/dreamm-3.0.1-linux-x64.tgz
                fd dreamm -e tgz ${config.home.homeDirectory}/Games -x ouch d {} -d ${config.home.homeDirectory}/Games
                ## SheepShaver
                sd '-SKIPINTDEPCHECK="0"' '-SKIPINTDEPCHECK="1"' ${config.xdg.configHome}/steamtinkerlaunch/global.conf
                xh https://api.github.com/repos/Korkman/macemu-appimage-builder/releases/latest | jq -r '.assets[] | select(.name | test("x86_64.AppImage$")).browser_download_url' | xargs xh get -d -o ${config.home.homeDirectory}/.local/bin/sheepshaver.appimage
                ## MoonDeck Buddy
                xh https://api.github.com/repos/FrogTheFrog/moondeck-buddy/releases/latest | jq -r '.assets[] | select(.name | test("x86_64.AppImage$")).browser_download_url' | xargs xh get -d -o ${config.home.homeDirectory}/.local/bin/moondeckbuddy.appimage
                ## Conty
                xh https://api.github.com/repos/Kron4ek/conty/releases/latest | jq -r '.assets[] | select(.name | test("conty_lite.sh$")).browser_download_url' | xargs xh get -d -o ${config.home.homeDirectory}/.local/bin/conty_lite.sh
                chmod +x ${config.home.homeDirectory}/.local/bin/conty_lite.sh
              '';
            })
            /*
              (writeShellApplication {
                         name = "script-pipewire-sink-helper";
                         runtimeInputs = [
                           coreutils
                           perl
                           pulseaudio
                         ];
                         text = ''
                           # Compiled from
                           # https://unix.stackexchange.com/questions/622987/send-music-from-specific-application-to-certain-sound-output-via-command-line
                           # https://bbs.archlinux.org/viewtopic.php?pid=1693617#p1693617
                           # https://forums.linuxmint.com/viewtopic.php?t=328616
                           # Set switches
                           app=$1
                           out=$2

                           # Collect all sinks
                           sinkList=$(pactl list sinks | tr '\n' '\r' | perl -pe 's/Sink #([0-9]+).+?device\.description = "([^\r]+)"\r.+?(?=Sink #|$)/\1:"\2",/g' | tr '\r' '\n')
                           IFS="," read -ra sinksArray <<< "$sinkList"

                           # Is our Hi-fi sink available? → Use for loop with indexes to handle spaces in names
                           for ((i = 0; i < ''${#sinksArray[@]}; i++)); do
                             sink="''${sinksArray[$i]}"
                             echo "sink found: $sink"

                             # Search for this output device's name
                             [[ "$sink" =~ "Game" ]] && hifiSinkIndex=$(echo "$sink" | cut -d':' -f1)
                           done

                           if [[ $hifiSinkIndex ]]; then
                             echo "Game has index $hifiSinkIndex"

                             # Collect all sound streams
                             musicSourcesList=$(pactl list sink-inputs | tr '\n' '\r' | perl -pe 's/Sink Input #([0-9]+).+?application\.process\.binary = "([^\r]+)"\r.+?(?=Sink Input #|$)/\1:\2\r/g' | tr '\r' '\n')

                             for soundSource in $musicSourcesList; do
                               binary=$(echo "$soundSource" | cut -d':' -f2);
                               index=$(echo "$soundSource" | cut -d':' -f1);
                               echo "index: $index, binary: $binary";

                               if [[ "$binary" == "wine64-preloader" ]]; then
                                 echo "moving $binary output to $hifiSinkIndex"
                                 pactl move-sink-input "$index" "$hifiSinkIndex"
                               fi
                             done
                           else
                             echo "Hi-fi sink was not found"
                           fi
                         '';
                       })
            */
          ]
          ++ lib.flatten (lib.attrValues p);
        services = {
          flatpak = {
            overrides = {
              "ca.parallel_launcher.ParallelLauncher" = {
                Context = {
                  filesystems = [ "/mnt/crusader/Games/Rom/No-Intro/roms" ];
                };
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
              "com.github.mtkennerly.ludusavi" = {
                Context = {
                  filesystems = [
                    "~/.var/app/com.heroicgameslauncher.hgl"
                    "~/.var/app/com.valvesoftware.Steam"
                    "~/.var/app/com.usebottles.bottles"
                    "~/.var/app/net.lutris.Lutris"
                    "${config.home.homeDirectory}/Games"
                    "/mnt/crusader/Games/Saves"
                    "xdg-data/games"
                  ];
                };
              };
              "com.github.keriew.augustus" = {
                Context = {
                  filesystems = [ "${config.home.homeDirectory}/Games/caesar-3" ];
                  shared = "network"; # obs-gamecapture
                };
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
              "com.github.Xenoveritas.abuse" = {
                Context = {
                  shared = "network"; # obs-gamecapture
                };
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
              "com.heroicgameslauncher.hgl" = {
                Context = {
                  filesystems = [
                    "${config.home.homeDirectory}/Games"
                    "xdg-data/games"
                  ];
                };
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
              "com.supermodel3.Supermodel" = {
                Context = {
                  filesystems = [
                    "xdg-data/supermodel"
                    "xdg-config/supermodel"
                    "!home"
                  ];
                };
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
              "com.usebottles.bottles" = {
                Context = {
                  filesystems = [
                    "${config.home.homeDirectory}/Games"
                    "/mnt/crusader/Games"
                    "~/.var/app/com.valvesoftware.Steam"
                    "~/.var/app/net.lutris.Lutris"
                    "xdg-data/applications"
                    "xdg-data/games"
                    "xdg-data/Steam"
                  ];
                };
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
              "com.valvesoftware.Steam" = {
                Context = {
                  filesystems = [
                    "${config.home.homeDirectory}/Games"
                    "xdg-data/games"
                  ];
                };
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
              "dev.lizardbyte.app.Sunshine" = {
                Context = {
                  filesystems = [ "!home" ];
                };
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
              "dev.opengoal.OpenGOAL" = {
                Context = {
                  filesystems = [ "${config.home.homeDirectory}/Games/opengoal" ];
                };
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
              "info.cemu.Cemu" = {
                Context = {
                  filesystems = [ "/mnt/crusader/Games/Rom/Other/Wii U" ];
                };
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
              "io.github.antimicrox.antimicrox" = {
                Context = {
                  filesystems = [ "!home" ];
                };
              };
              "io.github.ihhub.Fheroes2" = {
                Context = {
                  shared = "network"; # obs-gamecapture
                };
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
              "io.github.ja2_stracciatella.JA2-Stracciatella" = {
                Context = {
                  filesystems = [ "${config.home.homeDirectory}/Games/jagged-alliance-2/ja2" ];
                };
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
              "io.github.lime3ds.Lime3DS" = {
                Context = {
                  filesystems = [ "/mnt/crusader/Games/Rom/Other/Nintendo 3DS" ];
                };
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
              "io.github.theforceengine.tfe" = {
                Context = {
                  shared = "network"; # obs-gamecapture
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
                  filesystems = [ "${config.home.homeDirectory}/Games/RCT" ];
                };
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
              "net.lutris.Lutris" = {
                Context = {
                  filesystems = [
                    "${config.home.homeDirectory}/Games"
                    "/mnt/crusader/Games"
                    "xdg-data/games"
                  ];
                };
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
              "net.mancubus.SLADE" = {
                Context = {
                  filesystems = [
                    "~/.slade3"
                    "~/.slade"
                    "${config.home.homeDirectory}/Games/doom"
                    "!home"
                  ];
                };
              };
              "net.pcsx2.PCSX2" = {
                Context = {
                  filesystems = [ "/mnt/crusader/Games/Rom/Redump/Sony Playstation 2" ];
                };
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
              "net.rpcs3.RPCS3" = {
                Context = {
                  filesystems = [
                    "/mnt/crusader/Games/Other/RPCS3"
                    "${config.home.homeDirectory}/Games/RPCS3"
                    "!home"
                  ];
                };
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
              "org.DolphinEmu.dolphin-emu" = {
                Context = {
                  filesystems = [
                    "/mnt/crusader/Games/Rom/Redump/Nintendo Wii"
                    "/mnt/crusader/Games/Rom/Redump/Nintendo GameCube"
                  ];
                };
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
              "org.duckstation.DuckStation" = {
                Context = {
                  filesystems = [ "/mnt/crusader/Mister/PSX" ];
                };
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
              "org.easyrpg.player" = {
                Context = {
                  filesystems = [
                    "${config.home.homeDirectory}/Music/soundfonts:ro"
                    "${config.home.homeDirectory}/Games/rpg-maker"
                    "!host"
                  ];
                  shared = "network"; # obs-gamecapture
                };
                Environment = {
                  PULSE_SINK = "Game";
                  RPG2K_RTP_PATH = "${config.home.homeDirectory}/Games/rpg-maker/RTP/2000";
                  RPG2K3_RTP_PATH = "${config.home.homeDirectory}/Games/rpg-maker/RTP/2003";
                };
              };
              "org.libretro.RetroArch" = {
                Context = {
                  filesystems = [
                    "/mnt/crusader/Games/Rom"
                    "/mnt/crusader/Mister/games"
                  ];
                };
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
              "org.mamedev.MAME" = {
                Context = {
                  filesystems = [
                    "${config.home.homeDirectory}/Games"
                    "/mnt/crusader/Games/Rom/MAME"
                    "!home"
                  ];
                };
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
              "org.openmw.OpenMW" = {
                Context = {
                  filesystems = [ "${config.home.homeDirectory}/Games/morrowind" ];
                  shared = "network"; # obs-gamecapture
                };
                Environment = {
                  OSG_VERTEX_BUFFER_HINT = "VERTEX_BUFFER_OBJECT";
                  PULSE_SINK = "Game";
                };
              };
              "org.ryujinx.Ryujinx" = {
                Context = {
                  filesystems = [
                    "/mnt/crusader/Games/Rom/Other/Switch"
                    "!home"
                  ];
                };
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
              "org.scummvm.ScummVM" = {
                Context = {
                  filesystems = [
                    "${config.home.homeDirectory}/Games/scummvm"
                    "~/Music"
                    "!home"
                  ];
                };
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
              "org.zdoom.Raze" = {
                Context = {
                  filesystems = [ "${config.home.homeDirectory}/Games/duke3d" ];
                };
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
              "page.kramo.Cartridges" = {
                Context = {
                  filesystems = [
                    "${config.home.homeDirectory}/Games"
                    "xdg-data/games"
                  ];
                };
              };
            };
            packages = [
              "app.xemu.xemu"
              "ca.parallel_launcher.ParallelLauncher"
              "com.corsixth.corsixth"
              "com.etlegacy.ETLegacy"
              "com.fightcade.Fightcade"
              "com.fightcade.Fightcade.Wine"
              "com.github.mtkennerly.ludusavi"
              "com.github.keriew.augustus"
              "com.github.opentyrian.OpenTyrian"
              "com.github.optyfr.JRomManager"
              "com.github.Xenoveritas.abuse"
              "com.heroicgameslauncher.hgl"
              "com.obsproject.Studio.Plugin.InputOverlay"
              "com.obsproject.Studio.Plugin.OBSVkCapture"
              "com.parsecgaming.parsec"
              "com.qzandronum.Q-Zandronum"
              "com.richwhitehouse.BigPEmu"
              "com.spacestation14.Launcher"
              "com.supermodel3.Supermodel"
              "com.usebottles.bottles"
              "com.valvesoftware.Steam"
              # "dev.goats.xivlauncher"
              "dev.opengoal.OpenGOAL"
              "eu.vcmi.VCMI"
              "info.cemu.Cemu"
              "info.urbanterror.UrbanTerror"
              # "io.github.am2r_community_developers.AM2RLauncher"
              "io.github.Foldex.AdwSteamGtk"
              # "io.github.garglk.Gargoyle"
              "io.github.ihhub.Fheroes2"
              "io.github.ja2_stracciatella.JA2-Stracciatella"
              "io.github.lime3ds.Lime3DS"
              "io.github.limo_app.limo"
              "io.github.lxndr.gswatcher"
              "io.github.noxworld_dev.OpenNox"
              "io.github.RobertBeckebans.RBDoom3BFG-GL"
              "io.github.santiagocezar.maniatic-launcher"
              "io.github.simple64.simple64"
              "io.github.streetpea.Chiaki4deck"
              "io.github.theforceengine.tfe"
              "io.itch.tx00100xt.SeriousSamClassic-VK"
              "io.openrct2.OpenRCT2"
              "net._86box._86Box"
              "net._86box._86Box.ROMs"
              "net.darkradiant.DarkRadiant"
              "net.davidotek.pupgui2"
              "net.fsuae.FS-UAE"
              "net.lutris.Lutris"
              "net.mancubus.SLADE"
              "net.pcsx2.PCSX2"
              "net.rpcs3.RPCS3"
              "net.runelite.RuneLite"
              "net.sourceforge.uqm_mods.UQM-MegaMod"
              "org.dhewm3.Dhewm3"
              "org.diasurgical.DevilutionX"
              "org.DolphinEmu.dolphin-emu"
              "org.duckstation.DuckStation"
              "org.easyrpg.player"
              "org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/24.08"
              "org.freedesktop.Platform.VulkanLayer.OBSVkCapture/x86_64/24.08"
              "org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/24.08"
              "org.freedesktop.Platform.VulkanLayer.vkBasalt/x86_64/24.08"
              "org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/23.08"
              "org.freedesktop.Platform.VulkanLayer.OBSVkCapture/x86_64/23.08"
              "org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/23.08"
              "org.freedesktop.Platform.VulkanLayer.vkBasalt/x86_64/23.08"
              #"org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/22.08"
              #"org.freedesktop.Platform.VulkanLayer.OBSVkCapture/x86_64/22.08"
              #"org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/22.08"
              #"org.freedesktop.Platform.VulkanLayer.vkBasalt/x86_64/22.08"
              "org.kartkrew.RingRacers"
              "org.libretro.RetroArch"
              "org.mamedev.MAME"
              "org.openfodder.OpenFodder"
              "org.openjkdf2.OpenJKDF2"
              "org.openmw.OpenMW"
              "org.openttd.OpenTTD"
              "org.pegasus_frontend.Pegasus"
              "org.ppsspp.PPSSPP"
              "org.prismlauncher.PrismLauncher"
              "org.ryujinx.Ryujinx"
              "org.scummvm.ScummVM"
              "org.sonic3air.Sonic3AIR"
              "org.srb2.SRB2"
              # "org.twinery.Twine"
              # "org.zdoom.Raze"
              "page.kramo.Cartridges"
              "sh.fhs.KatawaShoujoReEngineered"
              "tk.deat.Jazz2Resurrection"
              "vet.rsc.OpenRSC.Launcher"
            ];
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
                exec = "flatpak run --command=bottles-cli com.usebottles.bottles run -p \"GOG Galaxy\" -b \"GOG Galaxy\" -- %u";
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
