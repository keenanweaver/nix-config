{ lib, ... }:
{
  configurations.nixos.nixos-htpc.module.boot.kernel.sysctl."net.ipv4.tcp_mtu_probing" =
    lib.mkForce null;
}
