(final: prev: {
  cherry-doom = prev.callPackage ./cherry-doom { };
  doom64ex-plus = prev.callPackage ./doom64ex-plus { };
  gsr = prev.callPackage ./gpu-screen-recorder { };
  hypseus-singe = prev.callPackage ./hypseus-singe { };
  klassy = prev.callPackage ./klassy { };
  nugget-doom = prev.callPackage ./nugget-doom { };
  nuked-sc55 = prev.callPackage ./nuked-sc55 { };
  obs-input-overlay = prev.qt6.callPackage ./obs-input-overlay { };
  plymouth = prev.plymouth.overrideAttrs (
    { src, ... }:
    {
      version = "24.004.60-unstable-2024-08-28";

      src = src.override {
        rev = "ea83580a6d66afd2b37877fc75248834fe530d99";
        hash = "sha256-GQzf756Y26aCXPyZL9r+UW7uo+wu8IXNgMeJkgFGWnA=";
      };
    }
  );
  relive = prev.callPackage ./relive { };
})
