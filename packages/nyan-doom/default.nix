{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  dumb,
  fluidsynth,
  libGLU,
  libmad,
  libvorbis,
  libzip,
  portmidi,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nyan-doom";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "andrikpowell";
    repo = "nyan-doom";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IW1SONMHQq62E6jzco/za2mWDhL3leDxcqvWZfsSBao=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    dumb
    fluidsynth
    libGLU
    libmad
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
