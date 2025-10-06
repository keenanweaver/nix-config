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
      #inputs.openmw-nix.packages.${system}.openmw-dev
      inputs.openmw-nix.packages.${system}.openmw-validator
      tes3cmd
      openmw
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
      #am2rlauncher
      arx-libertatis # Arx Fatalis
      augustus # Caesar 3
      clonehero # Guitar Hero
      corsix-th # Theme Hospital
      isle-portable
      jazz2
      katawa-shoujo-re-engineered
      openjk # Jedi Academy
      openloco
      #inputs.chaotic.packages.${system}.openmohaa_git
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
        version = "8.4.0";
        src = fetchFromGitHub {
          owner = "MeridianOXC";
          repo = "OpenXcom";
          rev = "0598aeac811739e4cb3cdc39996c2eb573dd3b49";
          hash = "sha256-coAdsM0IEz9MRiO4sBvCXcmyVc39zFGJ5FIBDizMVRw=";
        };
      })
      openxray # STALKER
      prismlauncher # MineCraft
      relive # Oddworld
      rsdkv4
      sdlpop # Prince of Persia
      #serious-sam-classic-vulkan
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
      (retroarch.withCores (
        cores: with cores; [
          beetle-psx-hw
          beetle-saturn
          blastem
          mgba
        ]
      ))
      (scummvm.overrideAttrs {
        version = "3.0.0-unstable-10-03-2025";
        src = fetchFromGitHub {
          owner = "scummvm";
          repo = "scummvm";
          rev = "acab8019c1e923a5f1798a027354f85dc6eae919";
          hash = "sha256-Fj6uzx0M72MKUMq4tmMhT0tP4qlLRGjazCJ1B/R3DEw=";
        };
      })
      inputs.chaotic.packages.${system}.shadps4_git
      nur.repos.bandithedoge.sheepshaver-bin
      #nur.repos.novel2430.vita3k
      xenia-canary
      ## Input
      joystickwake
      oversteer
      sc-controller
      ## Launchers & utils
      cartridges
      nur.repos.rogreat.faugus-launcher
      ## Modding
      hedgemodmanager
      limo
      nexusmods-app-unfree
      ## Other
      adwsteamgtk
      chiaki-ng
      flips
      gst_all_1.gstreamer
      gst_all_1.gst-libav
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-vaapi
      gswatcher
      igir
      innoextract
      lgogdownloader
      parsec-bin
      protonplus
      tochd
      #xlink-kai
      xvidcore
      ## Wine
      inputs.nix-gaming.packages.${system}.wine-tkg
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
      installPackages = lib.mkOption {
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
      #_2ship2harkinian-git.enable = true;
      perfect-dark-git.enable = true;
      shipwright-git.enable = true;
      sm64coopdx = {
        enable = true;
        coopNet.openFirewall = true;
      };
      spaghetti-kart-git.enable = true;
      starship-sf64.enable = true;
    };

    security = {
      pam = {
        loginLimits = [
          # RPCS3
          {
            domain = "*";
            type = "hard";
            item = "memlock";
            value = "unlimited";
          }
          # RPCS3
          {
            domain = "*";
            type = "soft";
            item = "memlock";
            value = "unlimited";
          }
          {
            domain = "*";
            item = "nofile";
            type = "-";
            value = "2097152";
          }
          {
            domain = "*";
            item = "nofile";
            type = "soft";
            value = "64556";
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
      lsfg-vk = {
        enable = true;
        ui.enable = true;
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
            "${simracing-hwdb}/90-mmos.hwdb"
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
          (writeTextFile {
            name = "40-logitech-g920.rules";
            destination = "/etc/udev/rules.d/40-logitech-g920.rules";
            text = ''
              ATTR{idVendor}=="046d", ATTR{idProduct}=="c261", RUN+="${usb-modeswitch}/bin/usb_modeswitch -c '/etc/usb_modeswitch.d/046d:c261'"
            '';
          })
          # https://github.com/CachyOS/CachyOS-Settings/blob/master/usr/lib/udev/rules.d/50-sata.rules
          (writeTextFile {
            name = "50-sata.rules";
            destination = "/etc/udev/rules.d/50-sata.rules";
            text = ''
              ACTION!="remove", SUBSYSTEM=="scsi_host", KERNEL=="host*", ATTR{link_power_management_policy}="*", ATTR{link_power_management_policy}="max_performance"
            '';
          })
          # https://wiki.cachyos.org/configuration/general_system_tweaks/#how-to-enable-adios
          (writeTextFile {
            name = "60-ioschedulers.rules";
            destination = "/etc/udev/rules.d/60-ioschedulers.rules";
            text = ''
              # HDD
              ACTION!="remove", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
              # SSD
              ACTION!="remove", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="adios"
              # NVMe SSD
              ACTION!="remove", KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="adios"
            '';
          })
          # https://github.com/CachyOS/CachyOS-Settings/blob/master/usr/lib/udev/rules.d/69-hdparm.rules
          (writeTextFile {
            name = "69-hdparm.rules";
            destination = "/etc/udev/rules.d/69-hdparm.rules";
            text = ''
              ACTION!="remove", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", RUN+="${hdparm}/bin/hdparm -B 254 -S 0 /dev/%k"
            '';
          })
          (writeTextFile {
            name = "70-easysmx.rules";
            destination = "/etc/udev/rules.d/70-easysmx.rules";
            text = ''
              # EasySMX X05
              ACTION!="remove", SUBSYSTEM=="usb", ATTR{idProduct}=="0091", ATTR{idVendor}=="2f24", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
            '';
          })
          (writeTextFile {
            name = "70-gamesir.rules";
            destination = "/etc/udev/rules.d/70-gamesir.rules";
            text = ''
              # GameSir Cyclone 2 Wireless Controller; USB
              ## Nintendo Switch
              ACTION!="remove", SUBSYSTEM=="usb", ATTR{idProduct}=="2009", ATTR{idVendor}=="057e", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
              ## D-input/Sony
              ACTION!="remove", SUBSYSTEM=="usb", ATTR{idProduct}=="09cc", ATTR{idVendor}=="054c", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
              ## X-input/XBOX
              ACTION!="remove", SUBSYSTEM=="usb", ATTR{idProduct}=="1053", ATTR{idVendor}=="3537", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
              # GameSir Cyclone 2 Wireless Controller; 2.4GHz
              ## X-input/XBOX
              ACTION!="remove", SUBSYSTEM=="usb", ATTR{idProduct}=="100b", ATTR{idVendor}=="3537", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
              # GameSir Cyclone 2 Wireless Controller; Bluetooth
              ACTION!="remove", SUBSYSTEM=="input", ATTR{idProduct}=="8100", ATTR{idVendor}=="054c", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
            '';
          })
          # 8BitDo Firmware Updater https://gist.github.com/archeYR/d687de5e484ce7b45d6a94415a04f3dc
          (writeTextFile {
            name = "70-8bitdo.rules";
            destination = "/etc/udev/rules.d/70-8bitdo.rules";
            text = ''
              # 8BitDo Arcade Stick; Bluetooth (X-mode)
              ACTION!="remove", SUBSYSTEM=="input", ATTRS{name}=="8BitDo Arcade Stick", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
              # 8BitDo Ultimate 2.4G Wireless  Controller; USB/2.4Ghz
              ## X-mode
              ACTION!="remove", SUBSYSTEM=="usb", ATTR{idProduct}=="3106", ATTR{idVendor}=="2dc8", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
              ## D-mode
              ACTION!="remove", SUBSYSTEM=="usb", ATTR{idProduct}=="3012", ATTR{idVendor}=="2dc8", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
              # 8BitDo Ultimate 2C Wireless Controller; USB/2.4GHz
              ACTION!="remove", SUBSYSTEM=="usb", ATTR{idProduct}=="310a", ATTR{idVendor}=="2dc8", ENV{ID_INPUT_JOYSTICK}="1", TAG+="uaccess"
              # Firmware Updater
              ACTION!="remove", SUBSYSTEM=="hidraw", ATTRS{idProduct}=="*", ATTRS{idVendor}=="2dc8", TAG+="uaccess"
            '';
          })
          # https://wiki.starcitizen-lug.org/Sticks,-Throttles,-&-Pedals
          (writeTextFile {
            name = "70-flight-stick.rules";
            destination = "/etc/udev/rules.d/70-flight-stick.rules";
            text = ''
              # Thrustmaster
              ACTION!="remove", KERNEL=="hidraw*", ATTRS{idVendor}=="044f", ATTRS{idProduct}=="*", MODE="0660", TAG+="uaccess"
              # Virpil
              ACTION!="remove", KERNEL=="hidraw*", ATTRS{idVendor}=="3344", ATTRS{idProduct}=="*", MODE="0660", TAG+="uaccess"
              ## Virpil Rudder Pedals
              ACTION!="remove", SUBSYSTEM=="input", KERNEL=="event*", \
                ENV{ID_VENDOR_ID}=="3344", ENV{ID_MODEL_ID}=="01f8", \
                RUN+="${linuxConsoleTools}/bin/evdev-joystick --e %E{DEVNAME} --d 0"
              # VKB
              ACTION!="remove", KERNEL=="hidraw*", ATTRS{idVendor}=="231d", ATTRS{idProduct}=="*", MODE="0660", TAG+="uaccess"
              ## VKB SEM
              ACTION!="remove", SUBSYSTEM=="input", KERNEL=="event*", \
                ENV{ID_VENDOR_ID}=="231d", ENV{ID_MODEL_ID}=="2204", \
                RUN+="${linuxConsoleTools}/bin/evdev-joystick --e %E{DEVNAME} --d 0"
              ## VKB Gunfighter L
              ACTION!="remove", SUBSYSTEM=="input", KERNEL=="event*", \
                ENV{ID_VENDOR_ID}=="231d", ENV{ID_MODEL_ID}=="0127", \
                RUN+="${linuxConsoleTools}/bin/evdev-joystick --e %E{DEVNAME} --d 0"
              ## VKB Gunfighter R
              ACTION!="remove", SUBSYSTEM=="input", KERNEL=="event*", \
                ENV{ID_VENDOR_ID}=="231d", ENV{ID_MODEL_ID}=="0126", \
                RUN+="${linuxConsoleTools}/bin/evdev-joystick --e %E{DEVNAME} --d 0"
            '';
          })
          (writeTextFile {
            name = "ntsync-udev-rules";
            destination = "/etc/udev/rules.d/70-ntsync.rules";
            text = ''
              KERNEL=="ntsync", MODE="0660", TAG+="uaccess"
            '';
          })
          # https://wiki.archlinux.org/title/Gamepad#Motion_controls_taking_over_joypad_controls_and/or_causing_unintended_input_with_joypad_controls
          (writeTextFile {
            name = "51-disable-DS3-and-DS4-motion-controls.rules";
            destination = "/etc/udev/rules.d/51-disable-DS3-and-DS4-motion-controls.rules";
            text = ''
              ACTION!="remove", SUBSYSTEM=="input", ATTRS{name}=="*Controller Motion Sensors", RUN+="${coreutils}/bin/rm %E{DEVNAME}", ENV{ID_INPUT_JOYSTICK}=""
            '';
          })
          # https://reddit.com/r/linux_gaming/comments/1fu4ggk/can_someone_explain_dualsense_to_me/lpwxv12/?context=3#lpwxv12
          (writeTextFile {
            name = "51-disable-dualsense-sound-and-vibration.rules";
            destination = "/etc/udev/rules.d/51-disable-dualsense-sound-and-vibration.rules";
            text = ''
              ACTION!="remove", KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", MODE="0660", TAG+="uaccess"
              ACTION!="remove", KERNEL=="hidraw*", KERNELS=="*054C:0CE6*", MODE="0660", TAG+="uaccess"
              ACTION!="remove", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", ENV{PULSE_IGNORE}="1", ENV{ACP_IGNORE}="1"
            '';
          })
        ];
      };
    };

    systemd = {
      settings.Manager = {
        DefaultLimitNOFILE = "8192:524288";
      };
      tmpfiles = {
        rules = [
          # AMD V-Cache https://wiki.cachyos.org/configuration/general_system_tweaks/#amd-3d-v-cache-optimizer
          "w /sys/bus/platform/drivers/amd_x3d_vcache/AMDI0101:00/amd_x3d_mode - - - - cache"
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
                    hash = "sha256-YWgK8Yh5G2kLBPr3+RjliB3n0aPH4I7IbKZTKzeXItI=";
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
            };
          packages = lib.mkIf cfg.installPackages (
            with pkgs;
            [
              (writeShellApplication {
                name = "doom-wad-extractor";
                runtimeInputs = [
                  fd
                  unzip
                ];
                runtimeEnv = {
                  IDGAMESARCHIVE_PATH = "/mnt/crusader/Games/Games/Doom/idgames";
                  OUTPUT_PATH = "${config.home.homeDirectory}/Games/doom/doom/pwads";
                };
                text = ''
                  # Check if search pattern was provided
                  if [ $# -eq 0 ]; then
                      echo "Usage: doom-wad-extractor <search_pattern> [additional_patterns...]"
                      echo "Example: doom-wad-extractor 'swtw' 'flotsam'"
                      echo ""
                      echo "Set IDGAMESARCHIVE_PATH environment variable to override default path"
                      echo "Current path: $IDGAMESARCHIVE_PATH"
                      exit 1
                  fi

                  # Push to the idgames directory
                  pushd "$IDGAMESARCHIVE_PATH" > /dev/null || exit 1

                  # Run fd with all provided arguments, filtering for archive files
                  echo "Searching for: $*"

                  # Combine all results from multiple fd searches
                  all_results=()
                  for pattern in "$@"; do
                      while IFS= read -r line; do
                          all_results+=("$line")
                      done < <(fd "$pattern" -e zip -e wad -e pk3)
                  done

                  # Remove duplicates and sort
                  mapfile -t results < <(printf '%s\n' "''${all_results[@]}" | sort -u)

                  # Check if any results were found
                  if [ ''${#results[@]} -eq 0 ]; then
                      echo "No files found matching: $1"
                      popd > /dev/null || exit 1
                      exit 1
                  fi

                  # Display results with numbers
                  echo -e "\nFound ''${#results[@]} file(s):"
                  for i in "''${!results[@]}"; do
                      printf "%d) %s\n" $((i+1)) "''${results[$i]}"
                  done

                  # Get user selection
                  echo -e "\nEnter the numbers to extract (space-separated, e.g., '1 3 5'), 'all' for all files, or press Enter for first result:"
                  read -r selection

                  # Default to first result if empty
                  if [ -z "$selection" ]; then
                      selection="1"
                  fi

                  # Create output directory if it doesn't exist
                  mkdir -p "$OUTPUT_PATH"

                  # Process selection
                  if [ "$selection" = "all" ]; then
                      selected_indices=("''${!results[@]}")
                  else
                      # Parse space-separated numbers
                      read -ra numbers <<< "$selection"
                      declare -A seen
                      selected_indices=()
                      for num in "''${numbers[@]}"; do
                          if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le ''${#results[@]} ]; then
                              idx=$((num-1))
                              if [ -z "''${seen[$idx]:-}" ]; then
                                  selected_indices+=("$idx")
                                  seen[$idx]=1
                              fi
                          else
                              echo "Warning: Invalid selection '$num' - skipping"
                          fi
                      done
                  fi

                  # Extract selected files
                  if [ ''${#selected_indices[@]} -eq 0 ]; then
                      echo "No valid selections made."
                  else
                      echo -e "\nProcessing ''${#selected_indices[@]} file(s) to $OUTPUT_PATH"
                      for idx in "''${selected_indices[@]}"; do
                          file="''${results[$idx]}"
                          filename=$(basename "$file")
                          extension="''${filename##*.}"
                          filename_no_ext="''${filename%.*}"

                          # Determine subfolder based on path
                          subfolder=""
                          file_lower=$(echo "$file" | tr '[:upper:]' '[:lower:]')
                          if [[ "$file_lower" == *"doom2"* ]]; then
                              subfolder="doom2"
                          elif [[ "$file_lower" == *"doom"* ]]; then
                              subfolder="doom"
                          fi

                          if [ -n "$subfolder" ]; then
                              target_dir="$OUTPUT_PATH/$subfolder/$filename_no_ext"
                          else
                              target_dir="$OUTPUT_PATH/$filename_no_ext"
                          fi

                          if [[ "$extension" =~ ^(wad|pk3)$ ]]; then
                              echo "Copying: $file"
                              mkdir -p "$target_dir"
                              cp "$file" "$target_dir/"
                          else
                              echo "Extracting: $file"
                              mkdir -p "$target_dir"
                              unzip -o -d "$target_dir" "$file"

                              # Check if there's a single directory with the same name (case-insensitive)
                              shopt -s nocasematch
                              for dir in "$target_dir"/*; do
                                  if [ -d "$dir" ]; then
                                      dir_name=$(basename "$dir")
                                      if [[ "$dir_name" == "$filename_no_ext" ]]; then
                                          echo "Flattening nested directory..."
                                          # Move contents up one level
                                          mv "$dir"/* "$target_dir/" 2>/dev/null || true
                                          # Remove the now-empty directory
                                          rmdir "$dir" 2>/dev/null || true
                                          break
                                      fi
                                  fi
                              done
                              shopt -u nocasematch
                          fi
                      done
                      echo -e "\nProcessing complete!"
                  fi

                  # Pop back to original directory
                  popd > /dev/null || exit 1
                '';
              })
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
                  wget -P "$GAMES_DIR"/dreamm $DREAMM
                  fd dreamm -e tgz "$GAMES_DIR"/dreamm -x tar xf {} -c "$GAMES_DIR"/dreamm
                  ## Conty
                  curl $CONTY | jq -r '.assets[] | select(.name | test("conty_lite.sh$")).browser_download_url' | xargs wget -P "$LOCAL_BIN"
                  chmod +x "$LOCAL_BIN"/conty_lite.sh
                '';
              })
              (writeShellApplication {
                name = "script-momw-update";
                runtimeEnv = {
                  MODLIST = "i-heart-vanilla-directors-cut";
                };
                runtimeInputs = [
                  inputs.openmw-nix.packages.${system}.momw-configurator
                  inputs.openmw-nix.packages.${system}.openmw-validator
                  inputs.openmw-nix.packages.${system}.umo
                  tes3cmd
                ];
                text = ''
                  umo sync "$MODLIST"
                  umo install "$MODLIST"
                  momw-configurator config "$MODLIST" --run-navmeshtool --run-validator
                  umo vacuum
                '';
              })
            ]
            ++ lib.flatten (lib.attrValues p)
          );
          sessionVariables = {
            # https://wiki.cachyos.org/configuration/gaming/#increase-maximum-shader-cache-size
            AMD_VULKAN_ICD = "RADV";
            MESA_SHADER_CACHE_MAX_SIZE = "12G";
            # https://reddit.com/r/linux_gaming/comments/1mg8vtl/low_latency_gaming_guide/
            MESA_VK_WSI_PRESENT_MODE = "fifo";
            SDL_VIDEODRIVER = "wayland,x11";
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
                    "${config.home.homeDirectory}/Games/cemu"
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
                    "${config.home.homeDirectory}/Games/switch"
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
                    "${config.home.homeDirectory}/Games/rpcs3"
                  ];
                };
              };
              "org.azahar_emu.Azahar" = {
                Context = {
                  filesystems = [
                    "${config.home.homeDirectory}/Games/3ds"
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
                    "${config.home.homeDirectory}/Games/rpg-maker"
                    "!home"
                    "!host"
                  ];
                  shared = "network"; # obs-gamecapture
                };
                Environment = {
                  RPG2K_RTP_PATH = "${config.home.homeDirectory}/Games/rpg-maker/RTP/2000";
                  RPG2K3_RTP_PATH = "${config.home.homeDirectory}/Games/rpg-maker/RTP/2003";
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
            };
            packages = [
              "app.xemu.xemu"
              "com.fightcade.Fightcade"
              "com.fightcade.Fightcade.Wine"
              {
                appId = "org.freedesktop.Platform.GL.mesa-git/x86_64/25.08";
                origin = "flathub-beta";
              }
              {
                appId = "org.freedesktop.Platform.GL32.mesa-git/x86_64/25.08";
                origin = "flathub-beta";
              }
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
              "info.beyondallreason.bar"
              "info.cemu.Cemu"
              "info.exult.exult"
              {
                appId = "io.github.hedge_dev.unleashedrecomp";
                bundle = "file://${config.home.homeDirectory}/Games/io.github.hedge_dev.unleashedrecomp.flatpak";
                sha256 = "13wca95yngfwl1y0c05y0b2w7aa8k3nkhvk46wsrxjvw3shb35im";
              }
              "io.github.noxworld_dev.OpenNox"
              "io.github.randovania.Randovania"
              "io.github.ryubing.Ryujinx"
              "io.github.santiagocezar.maniatic-launcher"
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
                  name = "CorsixTH";
                  files = [
                    "${config.xdg.configHome}/CorsixTH/Saves/*.sav"
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
                  path = "${config.home.homeDirectory}/Games/lutris";
                  store = "lutris";
                }
                {
                  path = "${config.home.homeDirectory}/Games/Bottles/*";
                  store = "otherWine";
                }
                {
                  path = "${config.home.homeDirectory}/Games/faugus/*";
                  store = "otherWine";
                }
                {
                  path = "${config.home.homeDirectory}/Games/Heroic/Prefixes/default/*";
                  store = "otherWine";
                }
                {
                  path = "${config.home.homeDirectory}/Games/nero/*";
                  store = "otherWine";
                }
                {
                  path = "${config.home.homeDirectory}/Games/portproton/*";
                  store = "otherWine";
                }
                {
                  path = "${config.home.homeDirectory}/Games/Steam";
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
