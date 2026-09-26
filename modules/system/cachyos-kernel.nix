{ inputs, ... }:
{
  flake.modules.nixos.cachyos-kernel = {
    # https://github.com/xddxdd/nix-cachyos-kernel?tab=readme-ov-file#binary-cache
    nix.settings = {
      extra-substituters = [ "https://attic.xuyh0120.win/lantian" ];
      extra-trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
    };
    nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
  };
  flake-file.inputs.nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
}
