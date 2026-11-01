{ inputs, ... }:
{
  flake.modules.nixos = {
    cachyos-kernel = {
      # https://github.com/xddxdd/nix-cachyos-kernel?tab=readme-ov-file#binary-cache
      nix.settings = {
        extra-substituters = [ "https://cache.lantian.pub/lantian" ];
        extra-trusted-public-keys = [ "lantian:WVGO7vsRMSEN+h7Lp7kv6SAmrkEXgUGbbXm7jMDjBuQ=" ];
      };
      nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
    };
    profile-base =
      { lib, pkgs, ... }:
      {
        boot = {
          # https://github.com/k4yt3x/sysctl
          kernel.sysctl = {
            "fs.file-max" = lib.mkDefault 9223372036854775807;
            "fs.inotify.max_user_watches" = 524288;
            "kernel.panic" = 10;
            "kernel.pid_max" = 4194304;
            "net.core.netdev_max_backlog" = lib.mkDefault 250000;
            "net.core.optmem_max" = 40960;
            "net.core.rmem_default" = 8388608;
            "net.core.rmem_max" = 536870912;
            "net.core.wmem_default" = 8388608;
            "net.core.wmem_max" = 536870912;
            "net.ipv4.ip_local_port_range" = "1024 65535";
            "net.ipv4.tcp_adv_win_scale" = -2;
            "net.ipv4.tcp_base_mss" = 1024;
            "net.ipv4.tcp_congestion_control" = "bbr";
            "net.ipv4.tcp_mtu_probing" = 1;
            "net.ipv4.tcp_notsent_lowat" = 131072;
            "net.ipv4.tcp_rmem" = "8192 262144 536870912";
            "net.ipv4.tcp_slow_start_after_idle" = 0;
            "net.ipv4.tcp_synack_retries" = 5;
            "net.ipv4.tcp_wmem" = "4096 16384 536870912";
          };
          kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
          zswap.enable = lib.mkDefault true;
        };
      };
  };
  flake-file.inputs.nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
}
