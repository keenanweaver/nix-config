{
  flake.modules.nixos.profile-gaming =
    { inputs, lib, ... }:
    {
      imports = [ inputs.cachyos-settings-nix.nixosModules.default ];
      boot.kernel.sysctl = {
        "kernel.nmi_watchdog" = lib.mkForce 0;
        "kernel.split_lock_mitigate" = 0;
        "net.ipv4.tcp_fin_timeout" = 5;
        "vm.page-cluster" = lib.mkForce 0;
      };
      cachyos.settings = {
        enable = true;
        zram.enable = lib.mkForce false;
      };
    };
  flake-file.inputs.cachyos-settings-nix = {
    inputs = {
      flake-parts.follows = "flake-parts";
      nixpkgs.follows = "nixpkgs";
    };
    url = "github:Daaboulex/cachyos-settings-nix";
  };
}
