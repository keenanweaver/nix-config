(final: prev: {
  fooyin = prev.callPackage ./fooyin { };
  inter = prev.callPackage ./inter { };
  isle-portable = prev.callPackage ./isle-portable { };
  klassy = prev.callPackage ./klassy { };
  lsfg-vk = prev.callPackage ./lsfg-vk { };
  lsfg-vk-ui = prev.callPackage ./lsfg-vk/ui.nix { };
  moondeck-buddy = prev.callPackage ./moondeck-buddy { };
  n64recomp = prev.callPackage ./zelda64recomp/n64recomp.nix { };
  nuked-sc55 = prev.callPackage ./nuked-sc55 { };
  nyan-doom = prev.callPackage ./nyan-doom { };
  plymouth = prev.plymouth.overrideAttrs (
    { src, ... }:
    {
      version = "24.004.60-unstable-2025-05-15";

      src = src.override {
        rev = "bc6c67dc1172a2041d275472f56948298ddde800";
        hash = "sha256-rR8ZoAoXlXpbgOAPrZwt65lykn0hbYJlRZJ/GFUobMo=";
      };
    }
  );
  relive = prev.callPackage ./relive { };
  rsdkv4 = prev.callPackage ./rsdkv4 { };
  tochd = prev.callPackage ./tochd { };
  xlink-kai = prev.callPackage ./xlink-kai { };
  z64decompress = prev.callPackage ./zelda64recomp/z64decompress.nix { };
  zelda64recomp = prev.callPackage ./zelda64recomp/zelda64recomp.nix { };
})
