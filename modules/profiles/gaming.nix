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
      arx-libertatis # Arx Fatalis
      clonehero # Guitar Hero
      exult # Ultima VII
      openjk # Jedi Academy
      openloco # Locomotion
      openxray # STALKER
      #relive # Oddworld
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
        alephone
        alephone-marathon
        alephone-durandal
        alephone-infinity
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
        quake3e
        #trenchbroom
      ]
      # Duke3D
      [
        eduke32
        #raze
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
        cartridges
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
      /*
        gst_all_1.gstreamer
           gst_all_1.gst-libav
           gst_all_1.gst-plugins-bad
           gst_all_1.gst-plugins-base
           gst_all_1.gst-plugins-good
           gst_all_1.gst-plugins-ugly
      */
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
    corectrl.enable = true;
    fluidsynth.enable = true;
    gamemode.enable = true;
    gamescope.enable = true;
    gpu-screen-recorder.enable = true;
    lact.enable = true;
    mangohud.enable = true;
    nonfree.enable = true;
    obs.enable = true;
    steam.enable = true;
    sunshine.enable = true;
    timidity.enable = true;
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
        kernelModules = lib.mkDefault [
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

    services = {
      hardware = {
        openrgb = {
          enable = true;
          package = pkgs.openrgb-with-all-plugins;
        };
      };
      #input-remapper.enable = true;
      #joycond.enable = true;
      pipewire = {
        configPackages = [
          (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/10-loopback-devices.conf" ''
            context.modules = [
                {   name = libpipewire-module-loopback
                    args = {
                            node.description = "Game capture"
                            audio.position = [ FL FR ]
                            capture.props = {
                                    media.class = Audio/Sink
                                    node.name = "Game"
                                    node.description = "Game"
                            }
                            playback.props = {
                                    node.name = "Game_m"
                                    node.description = "Game capture"
                            }
                    }
                }
                {   name = libpipewire-module-loopback
                    args = {
                            node.description = "Music capture"
                            audio.position = [ FL FR ]
                            capture.props = {
                                    media.class = Audio/Sink
                                    node.name = "Music"
                                    node.description = "Music"
                            }
                            playback.props = {
                                    node.name = "Music_m"
                                    node.description = "Music capture"
                            }
                    }
                }
                {   name = libpipewire-module-loopback
                    args = {
                            node.description = "Live-only capture"
                            audio.position = [ FL FR ]
                            capture.props = {
                                    media.class = Audio/Sink
                                    node.name = "Live-only"
                                    node.description = "Live-only"
                            }
                            playback.props = {
                                    node.name = "Live_m"
                                    node.description = "Live-only capture"
                            }
                    }
                }
                {   name = libpipewire-module-loopback
                    args = {
                            node.description = "VoIP capture"
                            audio.position = [ FL FR ]
                            capture.props = {
                                    media.class = Audio/Sink
                                    node.name = "VoIP"
                                    node.description = "VoIP"
                            }
                            playback.props = {
                                    node.name = "VoIP_m"
                                    node.description = "VoIP capture"
                            }
                    }
                }
            ]
          '')
        ];
      };
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
          roms-mt32-exodos = {
            enable = true;
            recursive = true;
            source = config.lib.file.mkOutOfStoreSymlink "${inputs.nonfree}/Music/mt-32";
            target = "${config.xdg.configHome}/distrobox/bazzite-arch-exodos/.config/dosbox/mt32-roms";
          };
          script-get-game-stuff = {
            enable = true;
            text = ''
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
                "Configure" = {
                  name = "Configure in Bottles";
                  exec = "bottles -b \"GOG Galaxy\"";
                };
              };
              settings = {
                StartupWMClass = "GOG Galaxy";
              };
            };
            portproton = {
              name = "PortProton";
              comment = "Proton launcher";
              exec = "portproton";
              icon = "${config.xdg.configHome}/distrobox/bazzite-arch-gaming/PortProton/data/img/w.png";
              categories = [ "Game" ];
              noDisplay = false;
              startupNotify = true;
            };
          };
        };
      };
  };
}
