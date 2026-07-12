{
  lib,
  stdenvNoCC,
  fetchzip,
  withOTF ? true,
  withTTF ? false,
}:

stdenvNoCC.mkDerivation rec {
  pname = "inter";
  version = "4.1";

  src = fetchzip {
    url = "https://github.com/rsms/inter/releases/download/v${version}/Inter-${version}.zip";
    stripRoot = false;
    hash = "sha256-5vdKKvHAeZi6igrfpbOdhZlDX2/5+UvzlnCQV6DdqoQ=";
  };

  installPhase = ''
    runHook preInstall

    ${lib.optionalString withTTF ''
      mkdir -p $out/share/fonts/truetype
      cp Inter.ttc InterVariable*.ttf $out/share/fonts/truetype
    ''}

    ${lib.optionalString withOTF ''
      mkdir -p $out/share/fonts/opentype
      cp extras/otf/*.otf $out/share/fonts/opentype
    ''}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://rsms.me/inter/";
    description = "Typeface specially designed for user interfaces";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ demize ];
  };
}
