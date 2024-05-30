{
  lib,
  username,
  pkgs,
  ...
}:
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
      availableKernelModules = lib.mkDefault [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "usbhid"
        "sd_mod"
        "sr_mod"
      ];
    };
    kernelModules = lib.mkDefault [
      "dm-snapshot"
      "hid-nintendo"
      "kvm-amd"
      "snd-seq"
      "snd-rawmidi"
      "tcp_bbr"
      "uinput"
    ];
    kernelParams = lib.mkDefault [
      "amd_iommu=on"
      "amd_pstate=guided"
    ];
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    #system76.power-daemon.enable = true;
  };

  networking = {
    #firewall.enable = lib.mkForce false;
    hostName = "nixos-desktop";
    wireless.enable = false;
  };

  services = {
    pipewire = {
      configPackages = [
        (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/10-clock-allowed-rates.conf" ''
          context.properties = {
              default.clock.allowed-rates = [ 44100 48000 88200 96000 ]
          }
        '')
        (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/10-loopback-mono-mic.conf" ''
          context.modules = [
              {   name = libpipewire-module-loopback
                  args = {
                          node.description = "Samson G-Track Pro [MONO]"
                          capture.props = {
                              node.name = "capture.mono-microphone"
                              audio.position = [ FL ]
                              target.object = "alsa_input.usb-Samson_Technologies_Samson_G-Track_Pro_D0B3381619112B00-00.analog-stereo"
                              stream.dont-remix = true
                              node.passive = true
                          }
                          playback.props = {
                              media.class = "Audio/Source"
                              node.name = "mono-microphone"
                              audio.position = [ MONO ]
                          }
                      }
              }
          ]
        '')
      ];
    };
    udev = {
      extraRules = ''
        # GPU artifacting https://wiki.archlinux.org/title/AMDGPU#Screen_artifacts_and_frequency_problem
        #KERNEL=="card1", SUBSYSTEM=="drm", DRIVERS=="amdgpu", ATTR{device/power_dpm_force_performance_level}="high"
        # https://reddit.com/r/linux_gaming/comments/196tz6v/psa_amdgpu_power_management_may_fix_your/khxs3q3/?context=3 https://gitlab.freedesktop.org/drm/amd/-/issues/1500#note_825883
        KERNEL=="card1", SUBSYSTEM=="drm", DRIVERS=="amdgpu", ATTR{device/power_dpm_force_performance_level}="manual", ATTR{device/pp_power_profile_mode}="1"
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

  # https://discourse.nixos.org/t/how-to-properly-turn-off-wifi-on-boot-or-before-shutdown-or-reboot-in-nixos/38712/4
  systemd.services."disable-wifi-on-boot" = {
    restartIfChanged = false;
    description = "Disable wifi on boot via nmcli";
    after = [ "NetworkManager.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.networkmanager}/bin/nmcli radio wifi off";
      Type = "oneshot";
      RemainAfterExit = "true";
    };
  };

  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };

  home-manager.users.${username} =
    { config, username, ... }:
    {
      home.file = {
        script-bootstrap-baremetal-desktop = {
          enable = true;
          text = ''
            #!/usr/bin/env bash
            # Set up Distrobox containers
            distrobox assemble create --file ${config.xdg.configHome}/distrobox/distrobox.ini
            distrobox enter bazzite-arch-exodos -- bash -l -c "${config.xdg.configHome}/distrobox/bootstrap-ansible.sh"
            distrobox enter bazzite-arch-gaming -- bash -l -c "${config.xdg.configHome}/distrobox/bootstrap-ansible.sh"
            # Set up flatpaks
            sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
            flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
            /home/${username}/.local/bin/flatpak-install-all.sh
            curl https://api.github.com/repos/rustdesk/rustdesk/releases/latest | jq -r '.assets[] | select(.name | test(".*flatpak$")).browser_download_url' | wget -i- -N -P /home/${username}/Downloads
            fd 'rustdesk' /home/${username}/Downloads -e flatpak -x flatpak install -u -y
            # Game stuff
            /home/${username}/.local/bin/game-stuff.sh
          '';
          target = ".local/bin/bootstrap-baremetal.sh";
          executable = true;
        };
      };
      xdg = {
        desktopEntries = {
          foobar2000 = {
            name = "foobar2000";
            comment = "Launch foobar2000 using Bottles.";
            exec = "bottles-cli run -p foobar2000 -b foobar2000";
            icon = "/home/${username}/Games/Bottles/foobar2000/icons/foobar2000.png";
            categories = [
              "AudioVideo"
              "Player"
              "Audio"
            ];
            noDisplay = false;
            startupNotify = true;
            actions = {
              "Configure" = {
                name = "Configure in Bottles";
                exec = "bottles -b foobar2000";
              };
            };
            settings = {
              StartupWMClass = "foobar2000";
            };
          };
          qobuz = {
            name = "Qobuz";
            comment = "Launch Qobuz using Bottles.";
            exec = "bottles-cli run -p Qobuz -b Qobuz";
            icon = "/home/${username}/Games/Bottles/Qobuz/icons/Qobuz.png";
            categories = [
              "AudioVideo"
              "Player"
              "Audio"
            ];
            noDisplay = false;
            startupNotify = true;
            actions = {
              "Configure" = {
                name = "Configure in Bottles";
                exec = "bottles -b Qobuz";
              };
            };
            settings = {
              StartupWMClass = "Qobuz";
            };
          };
        };
      };
    };
}
