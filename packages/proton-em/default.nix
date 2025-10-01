{
  fetchzip,
  lib,
  proton-ge-bin,
}:
(proton-ge-bin.override {
  steamDisplayName = "Proton-EM";
}).overrideAttrs
  (
    finalAttrs: _: {
      pname = "proton-em";
      version = "10.0-2F";

      src = fetchzip {
        url = "https://github.com/Etaash-mathamsetty/Proton/releases/download/EM-${finalAttrs.version}/proton-EM-${finalAttrs.version}.tar.xz";
        hash = "sha256-usjEAYEue2tQmOasQM46F1t0qJ1ouVmPyfl2hVlBzOg=";
      };

      meta = {
        inherit (proton-ge-bin.meta)
          description
          license
          platforms
          sourceProvenance
          ;
        homepage = "https://github.com/Etaash-mathamsetty/Proton";
        maintainers = with lib.maintainers; [
          keenanweaver
        ];
      };
    }
  )
