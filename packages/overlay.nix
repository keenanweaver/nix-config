(final: prev: {
  cherry-doom = prev.callPackage ./cherry-doom { };
  doom64ex-plus = prev.callPackage ./doom64ex-plus { };
  doomrunner = prev.callPackage ./doomrunner { };
  gsr = prev.callPackage ./gpu-screen-recorder { };
  hypseus-singe = prev.callPackage ./hypseus-singe { };
  klassy = prev.callPackage ./klassy { };
  moondeck-buddy = prev.callPackage ./moondeck-buddy { };
  nugget-doom = prev.callPackage ./nugget-doom { };
  nuked-sc55 = prev.callPackage ./nuked-sc55 { };
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
  xlink-kai = prev.callPackage ./xlink-kai { };
})
