(final: prev: {
  _2ship2harkinian = prev.callPackage ./2ship2harkinian { };
  cherry-doom = prev.callPackage ./cherry-doom { };
  doom64ex-plus = prev.callPackage ./doom64ex-plus { };
  faugus-launcher = prev.callPackage ./faugus-launcher { };
  gpu-screen-recorder = prev.callPackage ./gpu-screen-recorder { };
  gpu-screen-recorder-gtk = prev.callPackage ./gpu-screen-recorder/gtk { };
  gpu-screen-recorder-ui = prev.callPackage ./gpu-screen-recorder/ui { };
  gpu-screen-recorder-notification = prev.callPackage ./gpu-screen-recorder/notif { };
  inter = prev.callPackage ./inter { };
  klassy = prev.callPackage ./klassy { };
  moondeck-buddy = prev.callPackage ./moondeck-buddy { };
  nugget-doom = prev.callPackage ./nugget-doom { };
  n64recomp = prev.callPackage ./zelda64recomp/n64recomp.nix { };
  nuked-sc55 = prev.callPackage ./nuked-sc55 { };
  openomf = prev.callPackage ./openomf { };
  perfect_dark = prev.callPackage ./perfect_dark { };
  plymouth = prev.plymouth.overrideAttrs (
    { src, ... }:
    {
      version = "24.004.60-unstable-2024-12-15";

      src = src.override {
        rev = "a0e8b6cf50114482e8b5d17ac2e99ff0f274d4c5";
        hash = "sha256-XRSWdmGnckIGdsX7ihXK0RV3X9OphtGZcKQ6IW9FUBo=";
      };
    }
  );
  relive = prev.callPackage ./relive { };
  starship-sf64 = prev.callPackage ./starship-sf64 { };
  soundfont-generaluser = prev.callPackage ./generaluser { };
  xlink-kai = prev.callPackage ./xlink-kai { };
  z64decompress = prev.callPackage ./zelda64recomp/z64decompress.nix { };
  zelda64recomp = prev.callPackage ./zelda64recomp/zelda64recomp.nix { };
})
