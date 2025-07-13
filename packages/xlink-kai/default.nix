{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xlink-kai";
  version = "7.4.45-651430714";

  src = fetchzip {
    url = "https://dist.teamxlink.co.uk/linux/debian/static/standalone/release/amd64/xlinkkai_${finalAttrs.version}_standalone_x86_64.tar.gz";
    hash = "sha256-+ZV3R6EybIEFC+oRV7tLIhgAeYxbi4Ss18g5ouBamTY=";
  };

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 kaiengine $out/bin
  '';

  meta = {
    description = "Global Network Gaming";
    homepage = "https://www.teamxlink.co.uk/";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
})