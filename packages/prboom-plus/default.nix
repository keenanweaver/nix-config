{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  SDL2,
  SDL2_mixer,
  SDL2_image,
  SDL2_net,
  fluidsynth,
  soundfont-fluid,
  portmidi,
  libopenmpt,
  libvorbis,
  libmad,
  libGLU,
  pcre,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prboom-plus";
  version = "2.6.66";

  src = fetchFromGitHub {
    owner = "coelckers";
    repo = "prboom-plus";
    rev = "v${finalAttrs.version}";
    hash = "sha256-moU/bZ2mS1QfKPP6HaAwWP1nRNZ4Ue5DFl9zBBrJiHw=";
  };

  sourceRoot = "${finalAttrs.src.name}/prboom2";

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    SDL2
    SDL2_mixer
    SDL2_image
    SDL2_net
    fluidsynth
    portmidi
    libopenmpt
    libvorbis
    libGLU
    libmad
    pcre
  ];

  prePatch = ''
    substituteInPlace src/m_misc.c --replace-fail \
      "/usr/share/sounds/sf3/default-GM.sf3" \
      "${soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2"

    substituteInPlace CMakeLists.txt --replace-fail \
      "cmake_minimum_required(VERSION 3.0)" \
      "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    homepage = "https://github.com/coelckers/prboom-plus";
    description = "Advanced, Vanilla-compatible Doom engine based on PrBoom";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.ashley ];
  };
})
