{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "plymouth-theme-steamos";
  version = "0-unstable-2024-09-11";

  src = fetchFromGitHub {
    owner = "arvigeus";
    repo = "plymouth-theme-steamos";
    rev = "2fa02f8497a80f1aad6429dcafc3bcbda760c6c8";
    hash = "sha256-Y01KFbV0AQjKDoAD3/xISxckHRW5k59Sc5CbLZjyfVs=";
  };

  installPhase = ''
    runHook preInstall

    themeDir=$out/share/plymouth/themes/steamos
    mkdir -p "$themeDir"
    cp steamos.plymouth "$themeDir/"
    cp -r resources "$themeDir/resources"

    substituteInPlace "$themeDir/steamos.plymouth" \
      --replace-fail "/usr/share/plymouth/themes/steamos/resources" "$themeDir/resources"

    runHook postInstall
  '';

  dontBuild = true;
  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Valve SteamOS boot splash theme for Plymouth";
    homepage = "https://github.com/arvigeus/plymouth-theme-steamos";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.linux;
  };
}
