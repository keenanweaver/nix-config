{ config, lib, pkgs, username, ... }:
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
  gaming.enable = false;

  boot = {
    initrd.availableKernelModules = lib.mkDefault [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
    kernelModules = lib.mkDefault [ "tcp_bbr" "kvm-amd" ]; #"v4l2loopback"
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
    sessionVariables = { };
    systemPackages = with pkgs; [ ];
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    system76.power-daemon.enable = true;
  };

  networking = {
    firewall = {
      allowedUDPPorts = [ 51821 ]; # Wireguard
      interfaces = { wg0 = { allowedTCPPorts = [ 993 ]; }; };
    };
    hostName = "nixos-laptop";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  services = {
    thermald.enable = true;
    udev = {
      extraRules = ''
        # GPU artifacting https://wiki.archlinux.org/title/AMDGPU#Screen_artifacts_and_frequency_problem
        #KERNEL=="card0", SUBSYSTEM=="drm", DRIVERS=="amdgpu", ATTR{device/power_dpm_force_performance_level}="high"
        # https://reddit.com/r/linux_gaming/comments/196tz6v/psa_amdgpu_power_management_may_fix_your/khxs3q3/?context=3 https://gitlab.freedesktop.org/drm/amd/-/issues/1500#note_825883
        KERNEL=="card0", SUBSYSTEM=="drm", DRIVERS=="amdgpu", ATTR{device/power_dpm_force_performance_level}="manual", ATTR{device/pp_power_profile_mode}="1"
      '';
    };
  };

  system.stateVersion = "23.11";

  /*     zramSwap = {
      enable = true;
      memoryPercent = 25;
    }; */
  #};

  home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
    home.file = {
      script-bootstrap-baremetal-laptop = {
        enable = true;
        recursive = false;
        text = ''
          #!/usr/bin/env bash
          # Set up Distrobox containers
          distrobox assemble create --file ${config.xdg.configHome}/distrobox/distrobox.ini
          distrobox enter bazzite-arch-sys -- bash -l -c "${config.xdg.configHome}/distrobox/bootstrap-bazzite-arch-sys.sh"
          # Set up flatpaks
          sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
          flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
          #flatpak --user remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
          /home/${username}/.local/bin/flatpak-install.sh
          /home/${username}/.local/bin/flatpak-install-sys.sh
          curl https://api.github.com/repos/rustdesk/rustdesk/releases/latest | jq -r '.assets[] | select(.name | test(".*flatpak$")).browser_download_url' | wget -i- -N -P /home/${username}/Downloads
          fd 'rustdesk' /home/${username}/Downloads -e flatpak -x flatpak install -u -y
          # Set up other things
          curl https://api.github.com/repos/Kron4ek/conty/releases/latest | jq -r '.assets[] | select(.name | test("conty_lite.sh$")).browser_download_url' | wget -i- -N -P /home/${username}/.local/bin
          chmod +x /home/${username}/.local/bin/conty_lite.sh
          #conty_lite.sh -u
        '';
        target = ".local/bin/bootstrap-baremetal.sh";
        executable = true;
      };
    };
    home.packages = with pkgs; [ bottles ];
    xdg = {
      desktopEntries = {
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
      };
    };
  };
}
