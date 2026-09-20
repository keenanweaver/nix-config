{
  flake.modules.nixos.profile-gaming =
    { inputs, lib, ... }:
    {
      imports = [ inputs.omniflake.flakes.cachyos-settings-nix.nixosModules.default ];
      boot.kernel.sysctl = {
        "kernel.nmi_watchdog" = lib.mkForce 0;
        "kernel.split_lock_mitigate" = 0;
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
