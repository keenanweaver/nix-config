{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfg = config.gaming;
in
{
  options = {
    gaming = {
      enable = lib.mkEnableOption "Enable Gaming module in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {

    imports = [
      ./gamepad.nix
      ./packages.nix
      ./racing.nix
    ];

    # Custom modules
    bottles.enable = true;
    cdemu.enable = true;
    coolercontrol.enable = true;
    fluidsynth.enable = true;
    gamemode.enable = false;
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
      extraModulePackages = with config.boot.kernelPackages; [
        zenergy
      ];
      kernelModules = [
        "zenergy"
      ];
      kernelParams = [
        "usbhid.mousepoll=8" # Reduce mouse polling rate to 125hz
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
          "net.core.netdev_max_backlog" = 4096;
          "vm.dirty_background_bytes" = 67108864;
          "vm.dirty_bytes" = 268435456;
          "vm.dirty_writeback_centisecs" = 1500;
          "vm.page-cluster" = 0;
          "vm.vfs_cache_pressure" = 50;
        };
      };
    };

    chaotic.mesa-git.enable = true;

    networking = {
      firewall = {
        allowedUDPPorts = [
          # Moonlight
          5353
          47998
          47999
          48000
          48002
          48010
        ];
        allowedTCPPorts = [
          # MoonDeck Buddy
          59999
          # Moonlight
          47984
          47989
          48010
        ];
      };
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

    programs = {
      streamcontroller.enable = true;
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
          (writeTextFile {
            name = "40-streamdeck.rules";
            text = builtins.readFile (
              pkgs.fetchurl {
                url = "https://raw.githubusercontent.com/streamduck-org/elgato-streamdeck/main/40-streamdeck.rules";
                hash = "sha256-hY0HHNQple+utWRfczQuvlcYWH0wt+zLk0h883lPpJY=";
              }
            );
            destination = "/etc/udev/rules.d/40-streamdeck.rules";
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
          ../../apps/ludusavi
        ];

        home = {
          file = {
            desktop-entry-dxvk =
              let
                configFile = pkgs.fetchurl {
                  url = "https://raw.githubusercontent.com/doitsujin/dxvk/master/dxvk.conf";
                  hash = "sha256-OydD9rHfPQlsKs+889mQ6DJ14aBePdQ/RWvTiEMQij4=";
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
                  hash = "sha256-hAZePm8o5/55IlSghWKhBJBi63JtKJQzGYDUn69u1oM=";
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
            vrr-off = {
              enable = true;
              source =
                with pkgs;
                lib.getExe (writeShellApplication {
                  name = "vrr-off";
                  runtimeInputs = [
                    kdePackages.libkscreen
                  ];
                  text = ''
                    kscreen-doctor output.DP-1.vrrpolicy.never
                  '';
                });
              target = "${config.home.homeDirectory}/Games/vrr-off.sh";
            };
            vrr-on = {
              enable = true;
              source =
                with pkgs;
                lib.getExe (writeShellApplication {
                  name = "vrr-on";
                  runtimeInputs = [
                    kdePackages.libkscreen
                  ];
                  text = ''
                    kscreen-doctor output.DP-1.vrrpolicy.automatic
                  '';
                });
              target = "${config.home.homeDirectory}/Games/vrr-on.sh";
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
              target = "${config.home.homeDirectory}/Games/wine-controller.reg";
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
              target = "${config.home.homeDirectory}/Games/wine-mouse-acceleration.reg";
            };
          };
          packages = with pkgs; [
            (writeShellApplication {
              name = "script-exodos-nuked";
              runtimeEnv = {
                EXODOS = "/mnt/crusader/eXo/eXoDOS/eXo/eXoDOS";
              };
              runtimeInputs = with pkgs; [
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
                GAMES_DIR = "${config.home.homeDirectory}/Games";
                LOCAL_BIN = "${config.home.homeDirectory}/.local/bin";
              };
              runtimeInputs = [
                coreutils
                findutils
                jq
                sd
                xh
              ];
              text = ''
                ## DREAMM
                xh get -d -o "$GAMES_DIR"/games/dreamm.tgz $DREAMM
                fd dreamm -e tgz "$GAMES_DIR"/games -x ouch d {} -d "$GAMES_DIR"/games
                ## SheepShaver
                xh https://api.github.com/repos/Korkman/macemu-appimage-builder/releases/latest | jq -r '.assets[] | select(.name | test("x86_64.AppImage$")).browser_download_url' | xargs xh get -d -o "$LOCAL_BIN"/sheepshaver.appimage
                ## Conty
                xh https://api.github.com/repos/Kron4ek/conty/releases/latest | jq -r '.assets[] | select(.name | test("conty_lite.sh$")).browser_download_url' | xargs xh get -d -o "$LOCAL_BIN"/conty_lite.sh
                chmod +x "$LOCAL_BIN"/conty_lite.sh
              '';
            })
          ];
          sessionVariables = {
            # https://gitlab.com/OpenMW/openmw/-/issues/6185
            OSG_VERTEX_BUFFER_HINT = "VERTEX_BUFFER_OBJECT";
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
                };
              };
              "com.fightcade.Fightcade" = {
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
              "net.sourceforge.uqm_mods.UQM-MegaMod" = {
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
              "org.easyrpg.player" = {
                Context = {
                  filesystems = [
                    "${config.home.homeDirectory}/Music/soundfonts:ro"
                    "${config.home.homeDirectory}/Games/games/rpg-maker"
                    "!host"
                  ];
                  shared = "network"; # obs-gamecapture
                };
                Environment = {
                  PULSE_SINK = "Game";
                  RPG2K_RTP_PATH = "${config.home.homeDirectory}/Games/games/rpg-maker/RTP/2000";
                  RPG2K3_RTP_PATH = "${config.home.homeDirectory}/Games/games/rpg-maker/RTP/2003";
                };
              };
              "org.openjkdf2.OpenJKDF2" = {
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
              "org.sonic3air.Sonic3AIR" = {
                Environment = {
                  PULSE_SINK = "Game";
                };
              };
            };
            packages = [
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
              "dev.opengoal.OpenGOAL"
              "io.github.hedge_dev.hedgemodmanager"
              "io.github.noxworld_dev.OpenNox"
              "io.github.randovania.Randovania"
              "io.github.santiagocezar.maniatic-launcher"
              "io.itch.tx00100xt.SeriousSamClassic-VK"
              "net.nmlgc.rec98.sh01"
              "net.sourceforge.uqm_mods.UQM-MegaMod"
              "org.easyrpg.player"
              "org.openfodder.OpenFodder"
              "org.openjkdf2.OpenJKDF2"
              "org.sonic3air.Sonic3AIR"
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
                  path = "${config.home.homeDirectory}/Games/Bottles/Battle.net";
                  store = "otherWine";
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
                  path = "${config.home.homeDirectory}/Games/Bottles/Uplay";
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
                # { name = "Game"; } # nuked-sc55 & fluidsynth will interfere with screensaver
                { name = "Music"; }
              ];
            };
          };
        };
      };
  };
}
