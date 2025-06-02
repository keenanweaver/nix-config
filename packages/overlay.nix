(final: prev: {
  _2ship2harkinian = prev.callPackage ./2ship2harkinian { };
  doom64ex-plus = prev.callPackage ./doom64ex-plus { };
  faugus-launcher = prev.callPackage ./faugus-launcher { };
  fooyin = prev.callPackage ./fooyin { };
  gpu-screen-recorder = prev.callPackage ./gpu-screen-recorder { };
  gpu-screen-recorder-ui = prev.callPackage ./gpu-screen-recorder/ui { };
  gpu-screen-recorder-notification = prev.callPackage ./gpu-screen-recorder/notif { };
  inter = prev.callPackage ./inter { };
  klassy = prev.callPackage ./klassy { };
  moondeck-buddy = prev.callPackage ./moondeck-buddy { };
  n64recomp = prev.callPackage ./zelda64recomp/n64recomp.nix { };
  nuked-sc55 = prev.callPackage ./nuked-sc55 { };
  nyan-doom = prev.callPackage ./nyan-doom { };
  perfect_dark = prev.callPackage ./perfect_dark { };
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
  starship-sf64 = prev.callPackage ./starship-sf64 { };
  xlink-kai = prev.callPackage ./xlink-kai { };
  z64decompress = prev.callPackage ./zelda64recomp/z64decompress.nix { };
  zelda64recomp = prev.callPackage ./zelda64recomp/zelda64recomp.nix { };
})
