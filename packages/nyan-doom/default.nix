{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  libopenmpt,
  fluidsynth,
  libGLU,
  libmad,
  libsndfile,
  libvorbis,
  libzip,
  portmidi,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nyan-doom";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "andrikpowell";
    repo = "nyan-doom";
    tag = "v" + finalAttrs.version;
    hash = "sha256-PTnRB6kEFWzdWuJ63a1cdsrHTb/3IT9afQuBLfwmdOQ=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    libopenmpt
    fluidsynth
    libGLU
    libmad
    libsndfile
    libvorbis
    libzip
    portmidi
    zlib
  ];

  sourceRoot = "${finalAttrs.src.name}/prboom2";

  meta = {
    description = "The most cuddly Doom Source Port, with an emphasis on innovative and quality-of-life features";
    homepage = "https://github.com/andrikpowell/nyan-doom";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ keenanweaver ];
    mainProgram = "nyan-doom";
    platforms = lib.platforms.all;
  };
})
