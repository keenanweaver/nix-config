{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  alsa-lib,
  pkg-config,
  SDL2,
  makeDesktopItem,
  copyDesktopItems,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nuked-sc55";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "nukeykt";
    repo = "Nuked-SC55";
    rev = "${finalAttrs.version}";
    sha256 = "sha256-ofobMU60liujiOAQfG6ubW/tcD7wI9OtLSFUFrBF/mQ=";
    fetchSubmodules = true;
  };

  patches = [
    ./basepath.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    copyDesktopItems
  ];

  buildInputs = [
    alsa-lib
    SDL2
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release" # https://github.com/nukeykt/Nuked-SC55/issues/100
  ];

  # Hardcode the $out path to the back.data file
  postPatch = ''
    sed -i 's|@out@|'"''${out}"'|g' src/mcu.cpp
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Nuked-SC55";
      exec = "nuked-sc55";
      desktopName = "Nuked-SC55";
      comment = "Roland SC-55 series emulation";
      categories = [ "Game" ];
    })
    (makeDesktopItem {
      name = "Nuked-SC55_silent";
      exec = "nuked-sc55 -i";
      desktopName = "Nuked-SC55 (silent)";
      comment = "Roland SC-55 series emulation";
      categories = [ "Game" ];
    })
  ];

  meta = {
    description = "Roland SC-55 series emulation";
    homepage = "https://github.com/nukeykt/Nuked-SC55";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [ keenanweaver ];
    mainProgram = "nuked-sc55";
    platforms = lib.platforms.all;
  };
})
