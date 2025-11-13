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
  version = "0.3.1-unstable-10-13-2025";

  src = fetchFromGitHub {
    owner = "nukeykt";
    repo = "Nuked-SC55";
    rev = "dd2f525f15fe4580a8fbc59535170651ca559f59";
    hash = "sha256-dFyHxY5neVm6L59JBNwtIfsPZV8S/7G/1wL+2oUpHX0=";
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
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release") # https://github.com/nukeykt/Nuked-SC55/issues/100
  ];

  # Hardcode the $out path to the back.data file
  postPatch = ''
    sed -i 's|@out@|'"''${out}"'|g' src/mcu.cpp
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Nuked-SC55";
      exec = "env PIPEWIRE_NODE=MIDI PULSE_SINK=MIDI nuked-sc55";
      desktopName = "Nuked-SC55";
      comment = "Roland SC-55 series emulation";
      categories = [ "Game" ];
    })
    (makeDesktopItem {
      name = "Nuked-SC55_silent";
      exec = "env PIPEWIRE_NODE=MIDI PULSE_SINK=MIDI nuked-sc55 -i";
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
