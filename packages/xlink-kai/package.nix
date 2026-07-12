{
  lib,
  stdenv,
  fetchurl,
}:
let
  patchVersion = "651430714";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "xlink-kai";
  version = "7.4.45";

  src = fetchurl {
    url = "https://dist.teamxlink.co.uk/linux/debian/static/standalone/release/amd64/xlinkkai_${finalAttrs.version}_${patchVersion}_standalone_x86_64.tar.gz";
    hash = "sha256-3X6ub1sOjzSCFQVgy+8FeviRUQpch3fNfM5xDfhOX+Q=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 kaiengine $out/bin

    runHook postInstall
  '';

  meta = {
    description = "P2P network that offers LAN-based gaming for classic consoles";
    homepage = "https://www.teamxlink.co.uk/";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ keenanweaver ];
    mainProgram = "kaiengine";
  };
})
