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
      version = "10.0-32";

      src = fetchzip {
        url = "https://github.com/Etaash-mathamsetty/Proton/releases/download/EM-${finalAttrs.version}/proton-EM-${finalAttrs.version}.tar.xz";
        hash = "sha256-xbo1LHYJCFa7Yi+SpmK+Z09qf0xsUimMI/0Q1SCnTxg=";
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
