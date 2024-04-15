{ inputs, home-manager, lib, config, username, ... }: with lib;
let
  cfg = config.hardening;
in
{
  options = {
    hardening = {
      enable = mkEnableOption "Enable hardening in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    boot = {
      blacklistedKernelModules = [
        # Filesystems
        "adfs"
        "affs"
        "bfs"
        "befs"
        "cramfs"
        "efs"
        "erofs"
        "exofs"
        "f2fs"
        "freevxfs"
        "gfs2"
        "hfs"
        "hfsplus"
        "hpfs"
        "jffs2"
        "jfs"
        "ksmbd"
        "minix"
        "nilfs2"
        "omfs"
        "qnx4"
        "qnx6"
        "squashfs"
        "sysv"
        #"udf" PS3 games
        "vivid"
        # Networking
        "af_802154"
        "appletalk"
        "atm"
        "ax25"
        "can"
        "dccp"
        "decnet"
        "econet"
        "ipx"
        "n-hdlc"
        "netrom"
        "p8022"
        "p8023"
        "psnap"
        "rds"
        "rose"
        "sctp"
        "tipc"
        "x25"
      ];
      kernel = {
        sysctl = {
          # Hardening https://madaidans-insecurities.github.io/guides/linux-hardening.html#sysctl and https://github.com/sioodmy/dotfiles/blob/main/system/core/schizo.nix
          "dev.tty.ldisc_autoload" = 0;
          "kernel.dmesg_restrict" = 1;
          "kernel.kexec_load_disabled" = 1;
          "kernel.kptr_restrict" = 2;
          "kernel.printk" = "3 3 3 3";
          "kernel.unprivileged_bpf_disabled" = 1;
          #"kernel.yama.ptrace_scope" = 2; Breaks Hunt: Showdown
          "net.core.bpf_jit_harden" = 2;
          "net.ipv4.conf.default.rp_filter" = 1;
          "net.ipv4.conf.all.rp_filter" = 1;
          "net.ipv4.conf.all.accept_source_route" = 0;
          "net.ipv4.conf.all.send_redirects" = 0;
          "net.ipv4.conf.default.send_redirects" = 0;
          "net.ipv4.conf.all.accept_redirects" = 0;
          "net.ipv4.conf.default.accept_redirects" = 0;
          "net.ipv4.conf.all.secure_redirects" = 0;
          "net.ipv4.conf.default.secure_redirects" = 0;
          "net.ipv4.icmp_echo_ignore_all" = 1;
          "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
          "net.ipv4.tcp_sack" = 0;
          "net.ipv4.tcp_dsack" = 0;
          "net.ipv4.tcp_fack" = 0;
          "net.ipv4.tcp_syncookies" = 1;
          "net.ipv4.tcp_rfc1337" = 1;
          "net.ipv4.tcp_fastopen" = 3;
          "net.ipv6.conf.all.accept_source_route" = 0;
          "net.ipv6.conf.all.accept_redirects" = 0;
          "net.ipv6.conf.default.accept_redirects" = 0;
          "net.ipv6.conf.all.accept_ra" = 0;
          "net.ipv6.conf.default.accept_ra" = 0;
          "vm.mmap_rnd_bits" = 32;
          "vm.mmap_rnd_compat_bits" = 16;
          "vm.unprivileged_userfaultfd" = 0;
        };
      };
      kernelParams = [
        # Hardening https://madaidans-insecurities.github.io/guides/linux-hardening.html#boot-parameters
        #"debugfs=off" OpenSnitch
        "init_on_alloc=1"
        "init_on_free=1"
        #"ipv6.disable=1"
        "lockdown=confidentiality"
        "oops=panic"
        "page_alloc.shuffle=1"
        "pti=on"
        "randomize_kstack_offset=on"
        "slab_nomerge"
        "vsyscall=none"
      ];
    };
    networking = {
      firewall = {
        enable = true;
      };
    };
    security = {
      pam = {
        sshAgentAuth.enable = true;
        services = {
          sddm = {
            enableKwallet = true;
            gnupg = {
              enable = true;
            };
          };
          login = {
            enableKwallet = true;
            gnupg = {
              enable = true;
            };
          };
        };
      };
      polkit.enable = true;
      rtkit.enable = true;
      sudo = {
        execWheelOnly = true;
        extraRules = [
          {
            commands =
              builtins.map
                (command: {
                  command = "/run/current-system/sw/bin/${command}";
                  options = [ "NOPASSWD" ];
                })
                [ "poweroff" "reboot" "nixos-rebuild" "nix-env" "shutdown" "systemctl" ];
            groups = [ "wheel" ];
          }
        ];
      };
    };
    services = {
      clamav = {
        # run 'sudo freshclam' for first time
        daemon = {
          enable = true;
        };
        fangfrisch = {
          enable = true;
        };
        scanner = {
          enable = true;
        };
        updater = {
          enable = true;
        };
      };
      opensnitch = {
        enable = true;
      };
    };
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: { };
  };
}
