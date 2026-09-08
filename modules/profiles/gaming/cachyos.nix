{
  flake.modules.nixos.profile-gaming =
    { inputs, lib, ... }:
    {
      imports = [ inputs.omniflake.flakes.cachyos-settings-nix.nixosModules.default ];
      boot.kernel.sysctl = {
        "fs.file-max" = lib.mkForce 9223372036854775807;
        "kernel.nmi_watchdog" = lib.mkForce 0;
        "kernel.split_lock_mitigate" = 0;
        "net.core.netdev_max_backlog" = lib.mkForce 250000;
        "net.ipv4.tcp_fin_timeout" = 5;
        "vm.page-cluster" = lib.mkForce 0;
      };
      cachyos.settings = {
        enable = true;
        ntsync.enable = lib.mkForce false;
        zram.enable = lib.mkForce false;
      };
    };
}
