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
      version = "10.0-2E";

      src = fetchzip {
        url = "https://github.com/Etaash-mathamsetty/Proton/releases/download/EM-${finalAttrs.version}/proton-EM-${finalAttrs.version}.tar.xz";
        hash = "sha256-iVlnnGgbkVXi15o0davNV2I5ToKhieUI4li/94egsfQ=";
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
