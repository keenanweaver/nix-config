{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sonic3air";
  version = "26.03.28.0";

  src = fetchzip {
    url = "https://github.com/Eukaryot/sonic3air/releases/download/v${finalAttrs.version}-stable/sonic3air_game.tar.gz";
    hash = "sha256-yJAo7Bb54DBieb0HzOP0II95njzBSFdGpv7el/5izUE=";
  };

  dontBuild = true;

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 sonic3air_linux "$out/lib/sonic3air/sonic3air_linux"
    cp -r data "$out/lib/sonic3air/"

    makeWrapper "$out/lib/sonic3air/sonic3air_linux" "$out/bin/sonic3air" \
      --chdir "$out/lib/sonic3air"

    install -Dm444 data/icon.png "$out/share/icons/hicolor/256x256/apps/sonic3air.png"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "sonic3air";
      exec = "sonic3air";
      icon = "sonic3air";
      desktopName = "Sonic 3 A.I.R.";
      comment = "Sonic 3 Angel Island Revisited – fan-made remaster of Sonic 3 & Knuckles";
      categories = [ "Game" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fan-made remaster of Sonic 3 & Knuckles built on the Oxygen Engine";
    longDescription = ''
      Sonic 3 A.I.R. (Angel Island Revisited) is a non-profit fan game that brings
      Sonic 3 & Knuckles into a modern engine with widescreen support, higher
      frame-rates, achievements, and many quality-of-life improvements.

      The game requires the original Sonic 3 & Knuckles ROM image to be provided
      by the user at first launch; it is not included.

      Tip: Place `Sonic_Knuckles_wSonic3.bin` at ~/.local/share/Sonic3AIR
    '';
    homepage = "https://sonic3air.org/";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "sonic3air";
  };
})
