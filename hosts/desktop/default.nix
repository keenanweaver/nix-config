{ inputs, home-manager, lib, config, username, pkgs, ... }:
{
  imports = [
    # System
    ./disko.nix
    ./hardware-configuration.nix
    ./impermanence.nix
    # Profiles
    ../../modules
  ];

  # Custom modules
  desktop.enable = true;
  gaming.enable = true;

  boot = {
    initrd = {
      availableKernelModules = lib.mkDefault [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
    };
    kernelModules = lib.mkDefault [ "dm-snapshot" "hid-nintendo" "kvm-amd" "snd-seq" "snd-rawmidi" "tcp_bbr" "uinput" ]; #"v4l2loopback"
    kernelParams = lib.mkDefault [ "amd_iommu=on" "amd_pstate=guided" ];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot.enable = true;
      timeout = 3;
    };
  };

  environment = {
    sessionVariables = {
      # https://reddit.com/r/linux_gaming/comments/1b9foom/workaround_for_cursor_movement_cutting_our_vrr_on/
      "KWIN_DRM_DELAY_VRR_CURSOR_UPDATES" = "1";
      "KWIN_FORCE_SW_CURSOR" = "1";
    };
    systemPackages = with pkgs; [ ];
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    system76.power-daemon.enable = true;
  };

  networking = {
    hostName = "nixos-desktop";
    wireless.enable = false;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  services = {
    btrfs.autoScrub.enable = true;
    udev = {
      extraRules = ''
        # GPU artifacting https://wiki.archlinux.org/title/AMDGPU#Screen_artifacts_and_frequency_problem
        #KERNEL=="card0", SUBSYSTEM=="drm", DRIVERS=="amdgpu", ATTR{device/power_dpm_force_performance_level}="high"
        # https://reddit.com/r/linux_gaming/comments/196tz6v/psa_amdgpu_power_management_may_fix_your/khxs3q3/?context=3 https://gitlab.freedesktop.org/drm/amd/-/issues/1500#note_825883
        KERNEL=="card0", SUBSYSTEM=="drm", DRIVERS=="amdgpu", ATTR{device/power_dpm_force_performance_level}="manual", ATTR{device/pp_power_profile_mode}="1"
      '';
    };
    xserver = {
      deviceSection = ''
        #Option "AsyncFlipSecondaries" "true"
        Option "TearFree" "true"
        Option "VariableRefresh" "true"
      '';
    };
  };

  system.stateVersion = "23.11";

  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };

  home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
    home.file = {
      script-bootstrap-baremetal-desktop = {
        enable = true;
        recursive = false;
        text = ''
          #!/usr/bin/env bash
          # Set up Distrobox containers
          distrobox assemble create --file ${config.xdg.configHome}/distrobox/distrobox.ini
          distrobox enter bazzite-arch-exodos -- bash -l -c "${config.xdg.configHome}/distrobox/bootstrap-bazzite-arch-exodos.sh"
          distrobox enter bazzite-arch-gaming -- bash -l -c "${config.xdg.configHome}/distrobox/bootstrap-bazzite-arch-gaming.sh"
          distrobox enter bazzite-arch-sys -- bash -l -c "${config.xdg.configHome}/distrobox/bootstrap-bazzite-arch-sys.sh"
          # Set up flatpaks
          sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
          flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
          /home/${username}/.local/bin/flatpak-install-all.sh
          curl https://api.github.com/repos/rustdesk/rustdesk/releases/latest | jq -r '.assets[] | select(.name | test(".*flatpak$")).browser_download_url' | wget -i- -N -P /home/${username}/Downloads
          fd 'rustdesk' /home/${username}/Downloads -e flatpak -x flatpak install -u -y
          # Set up other things
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
          #conty_lite.sh -u
        '';
        target = ".local/bin/bootstrap-baremetal.sh";
        executable = true;
      };
    };
    home.packages = with pkgs; [ ];
    xdg = {
      desktopEntries = {
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
        foobar2000 = {
          name = "foobar2000";
          comment = "Launch foobar2000 using Bottles.";
          exec = "bottles-cli run -p foobar2000 -b foobar2000";
          icon = "/home/${username}/Games/Bottles/foobar2000/icons/foobar2000.png";
          categories = [ "AudioVideo" "Player" "Audio" ];
          noDisplay = false;
          startupNotify = true;
          actions = {
            "Configure" = { name = "Configure in Bottles"; exec = "bottles -b foobar2000"; };
          };
          settings = {
            StartupWMClass = "foobar2000";
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
        qobuz = {
          name = "Qobuz";
          comment = "Launch Qobuz using Bottles.";
          exec = "bottles-cli run -p Qobuz -b Qobuz";
          icon = "/home/${username}/Games/Bottles/Qobuz/icons/Qobuz.png";
          categories = [ "AudioVideo" "Player" "Audio" ];
          noDisplay = false;
          startupNotify = true;
          actions = {
            "Configure" = { name = "Configure in Bottles"; exec = "bottles -b Qobuz"; };
          };
          settings = {
            StartupWMClass = "foobar2000";
          };
        };
      };
    };
  };
}
