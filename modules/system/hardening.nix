{
  flake.modules.nixos.profile-base =
    {
      inputs,
      lib,
      config,
      ...
    }:
    {
      imports = [ inputs.nix-mineral.nixosModules.nix-mineral ];
      # https://github.com/k4yt3x/sysctl
      boot.kernel.sysctl = {
        "fs.file-max" = 9223372036854775807;
        "fs.inotify.max_user_watches" = 524288;
        "kernel.panic" = 10;
        "kernel.pid_max" = 4194304;
        "net.core.netdev_max_backlog" = 250000;
        "net.core.optmem_max" = 40960;
        "net.core.rmem_default" = 8388608;
        "net.core.rmem_max" = 536870912;
        "net.core.wmem_default" = 8388608;
        "net.core.wmem_max" = 536870912;
        "net.ipv4.ip_local_port_range" = "1024 65535";
        "net.ipv4.tcp_adv_win_scale" = -2;
        "net.ipv4.tcp_base_mss" = 1024;
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.ipv4.tcp_mtu_probing" = lib.mkIf (config.networking.hostName != "nixos-htpc") 1;
        "net.ipv4.tcp_notsent_lowat" = 131072;
        "net.ipv4.tcp_rmem" = "8192 262144 536870912";
        "net.ipv4.tcp_slow_start_after_idle" = 0;
        "net.ipv4.tcp_synack_retries" = 5;
        "net.ipv4.tcp_wmem" = "4096 16384 536870912";
      };
      nix-mineral = {
        enable = true;
        filesystems.normal = {
          "/etc".enable = false;
          "/home".enable = false;
          "/var".enable = false;
          "/var/lib".enable = false;
          "/var/log".enable = false;
        };
        kernel-modules.disable = {
          auth_rpcgss = false;
          cdrom-related = false;
          grace = false;
          intelme-related = true;
          joystick-drivers = false;
          lockd = false;
          nfs = false;
          nfs_acl = false;
          nfs_layout_flexfiles = false;
          nfs_layout_nfsv41_files = false;
          nfs_localio = false;
          nfsd = false;
          nfsv3 = false;
          nfsv4 = false;
          rpcsec_gss_krb5 = false;
          sunrpc = false;
          udf = false; # PS3 games
        };
        preset = [
          "compatibility"
          "performance"
        ];
        settings = {
          kernel.strict-iommu = lib.mkIf (config.networking.hostName == "nixos-laptop") false; # if true, boot doesn't work
          misc.nix-wheel = true;
          network.random-mac = false;
        };
      };
      security = {
        pam.sshAgentAuth.enable = true;
        polkit.extraConfig = ''
          polkit.addRule(function(action, subject) {
              if (subject.isInGroup("wheel")) {
                  if (action.id.startsWith("org.freedesktop.udisks2.")) {
                      return polkit.Result.YES;
                  }
              }
          });
        '';
        sudo = {
          execWheelOnly = true;
          extraConfig = "Defaults !lecture,!pwfeedback";
          extraRules = [
            {
              commands =
                map
                  (command: {
                    command = "/run/current-system/sw/bin/${command}";
                    options = [ "NOPASSWD" ];
                  })
                  [
                    "poweroff"
                    "reboot"
                    "nixos-rebuild"
                    "nix-env"
                    "shutdown"
                    "systemctl"
                  ];
              users = [ "${config.my.user}" ];
            }
          ];
        };
      };
      services.fail2ban.enable = true;
    };
  flake-file.inputs.nix-mineral = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:cynicsketch/nix-mineral";
  };
}
