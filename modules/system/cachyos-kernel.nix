{ inputs, ... }:
{
  flake.modules.nixos.cachyos-kernel = {
    # https://github.com/xddxdd/nix-cachyos-kernel?tab=readme-ov-file#binary-cache
    nix.settings = {
      extra-substituters = [ "https://cache.lantian.pub/lantian" ];
      extra-trusted-public-keys = [ "lantian:WVGO7vsRMSEN+h7Lp7kv6SAmrkEXgUGbbXm7jMDjBuQ=" ];
    };
    nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
  };
  flake-file.inputs.nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
}
