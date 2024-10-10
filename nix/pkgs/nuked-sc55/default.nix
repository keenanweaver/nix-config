{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  alsa-lib,
  pkg-config,
  SDL2,
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
  ];

  buildInputs = [
    alsa-lib
    SDL2
  ];

  # Hardcode the $out path to the back.data file
  postPatch = ''
    sed -i 's|@out@|'"''${out}"'|g' src/mcu.cpp
  '';
})
