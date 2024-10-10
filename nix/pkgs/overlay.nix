(final: prev: {
  doom64ex-plus = prev.callPackage ./doom64ex-plus { };
  klassy = prev.callPackage ./klassy { };
  nuked-sc55 = prev.callPackage ./nuked-sc55 { };
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
  rigel-engine = prev.callPackage ./rigel { };
})
