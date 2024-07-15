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
  dxvkConfig = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/doitsujin/dxvk/master/dxvk.conf";
    hash = "sha256-dt+IlHYw+IjjHNFDT9PgXft682uwB1pGv75SLZDvJcE=";
  };
  vkBasaltConfig = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/DadSchoorse/vkBasalt/master/config/vkBasalt.conf";
    hash = "sha256-IN/Kuc17EZfzRoo8af1XoBX2/48/bCdyOxw/Tl463Mg=";
  };
  p = with pkgs; {
    games = [
      arx-libertatis # Arx Fatalis
      clonehero # Guitar Hero
      exult # Ultima VII
      #inputs.ow-mod-man.packages.${system}.owmods-cli
      #inputs.ow-mod-man.packages.${system}.owmods-gui
      openjk # Jedi Academy
      openloco # Locomotion
      #openxray # STALKER
      #relive # Oddworld
      wipeout-rewrite # Wipeout
      vvvvvv
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
        woof-doom
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
        #alephone
        #alephone-marathon
        #alephone-durandal
        #alephone-infinity
      ]
      # N64
      [
        #_2s2h
        #shipwright
        #zelda64recomp
      ]
      # Quake
      [
        (ioquake3.overrideAttrs (attrs: {
          version = "unstable-2024-05-20";
          src = fetchFromGitHub {
            owner = "ioquake";
            repo = "ioq3";
            rev = "1fc83e4845b53a9b259f5980468c8db15fce8de7";
            hash = "sha256-qnIyNXPeSu/vJfURw7BG41qosAoKGS6NZR9cCb/9Cxw=";
          };
        }))
        ironwail
        #trenchbroom
      ]
      # Duke3D
      [
        eduke32
        raze
      ]
      # Star Citizen
      [
        inputs.nix-citizen.packages.${system}.star-citizen
        inputs.nix-citizen.packages.${system}.star-citizen-helper
      ]
      # Wolf
      [
        bstone
        ecwolf
        iortcw
      ]
    ];
    tools = [
      # Emulators 
      [
        #archipelago
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
        solaar
        xboxdrv
      ]
      # Graphics
      [
        glxinfo
        libstrangle
        vulkan-tools
      ]
      # Launchers 
      [
        bottles
        cartridges
        heroic
        lutris
      ]
      # Modding
      [
        #nexusmods-app-unfree
        (r2modman.overrideAttrs (attrs: {
          version = "3.1.49";
          src = fetchFromGitHub {
            owner = "ebkr";
            repo = "r2modmanPlus";
            rev = "v3.1.49";
            hash = "sha256-Br+VkBHgwM/Zu1aypzlVYHB/v8T/KV+B6XUNJn/EbYM=";
          };
          offlineCache = fetchYarnDeps {
            yarnLock = "https://github.com/ebkr/r2modmanPlus/blob/develop/yarn.lock";
            hash = "sha256-ntXZ4gRXRqiPQxdwXDsLxGdBqUV5eboy9ntTlJsz9FA=";
          };
        }))
      ]
      # Wine
      [
        inputs.nix-gaming.packages.${pkgs.system}.wine-discord-ipc-bridge
        winetricks
        wineWowPackages.stagingFull
      ]
      # GStreamer
      [
        gst_all_1.gstreamer
        gst_all_1.gstreamermm
        gst_all_1.gst-libav
        gst_all_1.gst-plugins-bad
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        gst_all_1.gst-plugins-rs
        gst_all_1.gst-plugins-ugly
        gst_all_1.gst-plugins-viperfx
        gst_all_1.gst-vaapi
      ]
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
    corectrl.enable = false;
    fluidsynth.enable = true;
    gamemode.enable = true;
    gamescope.enable = true;
    gsr.enable = true;
    lact.enable = true;
    mangohud.enable = true;
    nonfree.enable = true;
    obs.enable = true;
    steam.enable = true;
    sunshine.enable = false;
    timidity.enable = true;
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
      kernelModules = [ "gcadapter_oc" ];
      kernelParams = [ "split_lock_detect=off" ];
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
    /*
      nixpkgs.config.permittedInsecurePackages = [
        "freeimage-unstable-2021-11-01"
      ];
    */

    networking = {
      firewall = {
        # OW QSB KCP
        allowedTCPPorts = [ 7777 ];
        allowedUDPPorts = [ 7777 ];
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
            destination = "/etc/udev/rules.d/51-disable-DS3-and-DS4-motion-controls.rules";
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
          {
            domain = "*";
            item = "nofile";
            type = "hard";
            value = "1048576";
          }
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

    home-manager.users.${username} =
      {
        inputs,
        config,
        username,
        ...
      }:
      {
        home.file = {
          desktop-entry-dxvk = {
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
          desktop-entry-vkBasalt = {
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
            target = "${config.xdg.dataHome}/distrobox/bazzite-arch-exodos/.config/dosbox/mt32-roms";
          };
          script-get-game-stuff = {
            enable = true;
            text = ''
              #!/usr/bin/env bash
              ## SteamTinkerLaunch https://gist.github.com/jakehamilton/632edeb9d170a2aedc9984a0363523d3
              steamtinkerlaunch compat add
              steamtinkerlaunch
              sed -i -e 's/-SKIPINTDEPCHECK="0"/-SKIPINTDEPCHECK="1"/g' ${config.xdg.configHome}/steamtinkerlaunch/global.conf
              ## SheepShaver
              curl https://api.github.com/repos/Korkman/macemu-appimage-builder/releases/latest | jq -r '.assets[] | select(.name | test("x86_64.AppImage$")).browser_download_url' | wget -i- -N -P /home/${username}/.local/bin
              ## MoonDeck Buddy
              curl https://api.github.com/repos/FrogTheFrog/moondeck-buddy/releases/latest | jq -r '.assets[] | select(.name | test("x86_64.AppImage$")).browser_download_url' | wget -i- -N -P /home/${username}/.local/bin
              ## Conty
              curl https://api.github.com/repos/Kron4ek/conty/releases/latest | jq -r '.assets[] | select(.name | test("conty_lite.sh$")).browser_download_url' | wget -i- -N -P /home/${username}/.local/bin
              chmod +x /home/${username}/.local/bin/conty_lite.sh
            '';
            target = "/home/${username}/.local/bin/game-stuff.sh";
          };
          script-pipewire-sink-helper = {
            enable = true;
            text = ''
              #!/usr/bin/env bash
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
            target = "/home/${username}/.local/bin/sink-helper";
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
        services.flatpak = {
          overrides = {
            "com.github.mtkennerly.ludusavi" = {
              Context = {
                filesystems = [
                  "~/.var/app/com.valvesoftware.Steam"
                  "~/.var/app/com.usebottles.bottles"
                  "~/Games"
                  "/mnt/crusader/Games/Saves"
                ];
              };
            };
            "ca.parallel_launcher.ParallelLauncher" = {
              Context = {
                filesystems = [ "/mnt/crusader/Games/Rom/No-Intro/roms" ];
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
            };
            "dev.lizardbyte.app.Sunshine" = {
              Context = {
                filesystems = [ "!home" ];
              };
            };
            "dev.opengoal.OpenGOAL" = {
              Context = {
                filesystems = [ "/home/${username}/Games/opengoal" ];
              };
            };
            "info.cemu.Cemu" = {
              Context = {
                filesystems = [ "/mnt/crusader/Games/Rom/Other/Wii U" ];
              };
            };
            "io.github.antimicrox.antimicrox" = {
              Context = {
                filesystems = [ "!home" ];
              };
            };
            "io.github.ja2_stracciatella.JA2-Stracciatella" = {
              Context = {
                filesystems = [ "/home/${username}/Games/jagged-alliance-2/ja2" ];
              };
            };
            "io.github.lime3ds.Lime3DS" = {
              Context = {
                filesystems = [ "/mnt/crusader/Games/Rom/Other/Nintendo 3DS" ];
              };
            };
            "io.openrct2.OpenRCT2" = {
              Context = {
                filesystems = [ "/home/${username}/Games/RCT" ];
              };
            };
            "net.mancubus.SLADE" = {
              Context = {
                filesystems = [
                  "~/.slade3"
                  "~/.slade"
                  "/home/${username}/Games/doom"
                  "!home"
                ];
              };
            };
            "net.pcsx2.PCSX2" = {
              Context = {
                filesystems = [ "/mnt/crusader/Games/Rom/Redump/Sony Playstation 2" ];
              };
            };
            "net.rpcs3.RPCS3" = {
              Context = {
                filesystems = [
                  "/mnt/crusader/Games/Other/RPCS3"
                  "/home/${username}/Games/RPCS3"
                  "!home"
                ];
              };
            };
            "org.DolphinEmu.dolphin-emu" = {
              Context = {
                filesystems = [
                  "/mnt/crusader/Games/Rom/Redump/Nintendo Wii"
                  "/mnt/crusader/Games/Rom/Redump/Nintendo GameCube"
                ];
              };
            };
            "org.duckstation.DuckStation" = {
              Context = {
                filesystems = [ "/mnt/crusader/Mister/PSX" ];
              };
            };
            "org.easyrpg.player" = {
              Context = {
                filesystems = [
                  "/home/${username}/Music/soundfonts:ro"
                  "/home/${username}/Games/rpg-maker"
                  "!host"
                ];
              };
              Environment = {
                RPG2K_RTP_PATH = "/home/${username}/Games/rpg-maker/RTP/2000";
                RPG2K3_RTP_PATH = "/home/${username}/Games/rpg-maker/RTP/2003";
              };
            };
            "org.libretro.RetroArch" = {
              Context = {
                filesystems = [
                  "/mnt/crusader/Games/Rom"
                  "/mnt/crusader/Mister/games"
                ];
              };
            };
            "org.mamedev.MAME" = {
              Context = {
                filesystems = [
                  "/home/${username}/Games"
                  "/mnt/crusader/Games/Rom/MAME"
                  "!home"
                ];
              };
            };
            "org.openmw.OpenMW" = {
              Context = {
                filesystems = [ "/home/${username}/Games/morrowind" ];
              };
              Environment = {
                OSG_VERTEX_BUFFER_HINT = "VERTEX_BUFFER_OBJECT";
              };
            };
            "org.ryujinx.Ryujinx" = {
              Context = {
                filesystems = [
                  "/mnt/crusader/Games/Rom/Other/Switch"
                  "!home"
                ];
              };
            };
            "org.scummvm.ScummVM" = {
              Context = {
                filesystems = [
                  "~/Games/scummvm"
                  "~/Music"
                  "!home"
                ];
              };
            };
            "org.zdoom.Raze" = {
              Context = {
                filesystems = [ "/home/${username}/Games/duke3d" ];
              };
            };
          };
          packages = [
            "app.xemu.xemu"
            #"ca.parallel_launcher.ParallelLauncher"
            #"com.corsixth.corsixth"
            #"com.etlegacy.ETLegacy"
            "com.fightcade.Fightcade"
            "com.fightcade.Fightcade.Wine"
            #"com.github.Alcaro.Flips"
            "com.github.mtkennerly.ludusavi"
            #"com.github.keriew.augustus"
            #"com.github.opentyrian.OpenTyrian"
            #"com.github.optyfr.JRomManager"
            #"com.github.Xenoveritas.abuse"
            "com.obsproject.Studio.Plugin.Gstreamer"
            "com.obsproject.Studio.Plugin.GStreamerVaapi"
            "com.obsproject.Studio.Plugin.InputOverlay"
            "com.obsproject.Studio.Plugin.OBSVkCapture"
            #"com.parsecgaming.parsec"
            #"dev.opengoal.OpenGOAL"
            #"com.qzandronum.Q-Zandronum"
            #"com.richwhitehouse.BigPEmu"
            #"com.spacestation14.Launcher"
            #"com.supermodel3.Supermodel"
            #"eu.vcmi.VCMI"
            "info.cemu.Cemu"
            #"info.urbanterror.UrbanTerror"
            #"io.github.am2r_community_developers.AM2RLauncher"
            #"io.github.antimicrox.antimicrox"
            "io.github.Foldex.AdwSteamGtk"
            #"io.github.garglk.Gargoyle"
            #"io.github.ihhub.Fheroes2"
            #"io.github.ja2_stracciatella.JA2-Stracciatella"
            #"io.github.lethal_guitar.RigelEngine"
            "io.github.lime3ds.Lime3DS"
            "io.github.lxndr.gswatcher"
            #"io.github.santiagocezar.maniatic-launcher"
            #"io.github.simple64.simple64"
            #"io.github.theforceengine.tfe"
            #"io.itch.tx00100xt.SeriousSamClassic-VK"
            "io.openrct2.OpenRCT2"
            "net._86box._86Box"
            "net._86box._86Box.ROMs"
            #"net.darkradiant.DarkRadiant"
            "net.davidotek.pupgui2"
            "net.fsuae.FS-UAE"
            #"net.mancubus.SLADE"
            "net.pcsx2.PCSX2"
            "net.rpcs3.RPCS3"
            #"net.runelite.RuneLite"
            #"net.sourceforge.uqm_mods.UQM-MegaMod"
            #"org.dhewm3.Dhewm3"
            #"org.diasurgical.DevilutionX"
            "org.DolphinEmu.dolphin-emu"
            "org.duckstation.DuckStation"
            "org.easyrpg.player"
            "org.freedesktop.Platform.GStreamer.gstreamer-vaapi/x86_64/23.08"
            "org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/23.08"
            "org.freedesktop.Platform.VulkanLayer.OBSVkCapture/x86_64/23.08"
            "org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/23.08"
            "org.freedesktop.Platform.VulkanLayer.vkBasalt/x86_64/23.08"
            #"org.freedesktop.Platform.GStreamer.gstreamer-vaapi/x86_64/22.08"
            #"org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/22.08"
            #"org.freedesktop.Platform.VulkanLayer.OBSVkCapture/x86_64/22.08"
            #"org.freedesktop.Platform.VulkanLayer.gamescope/x86_64/22.08"
            #"org.freedesktop.Platform.VulkanLayer.vkBasalt/x86_64/22.08"
            #"org.godotengine.Godot"
            "org.kartkrew.RingRacers"
            #"org.kde.kigo"
            "org.libretro.RetroArch"
            "org.mamedev.MAME"
            #"org.openfodder.OpenFodder"
            #"org.openjkdf2.OpenJKDF2"
            #"org.openmw.OpenMW"
            #"org.openttd.OpenTTD"
            #"org.pegasus_frontend.Pegasus"
            #"org.ppsspp.PPSSPP"
            #"org.prismlauncher.PrismLauncher"
            "org.ryujinx.Ryujinx"
            "org.scummvm.ScummVM"
            "org.sonic3air.Sonic3AIR"
            #"org.srb2.SRB2"
            #"org.twinery.Twine"
            #"org.zdoom.Raze"
            #"re.chiaki.Chiaki"
            #"ru.linux_gaming.PortProton"
            #"sh.fhs.KatawaShoujoReEngineered"
            #"tk.deat.Jazz2Resurrection"
            #"vet.rsc.OpenRSC.Launcher"
          ];
        };
        xdg = {
          desktopEntries = {
            gog-galaxy = {
              name = "GOG Galaxy";
              comment = "Launch GOG Galaxy using Bottles.";
              exec = "bottles-cli run -p \"GOG Galaxy\" -b \"GOG Galaxy\"";
              icon = "/home/${username}/Games/Bottles/GOG-Galaxy/icons/GOG Galaxy.png";
              categories = [ "Game" ];
              noDisplay = false;
              startupNotify = true;
              actions = {
                "Configure" = {
                  name = "Configure in Bottles";
                  exec = "bottles -b \"GOG Galaxy\"";
                };
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
