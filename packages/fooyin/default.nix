{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsa-lib,
  ffmpeg,
  flac,
  kdePackages,
  kdsingleapplication,
  pipewire,
  taglib,
  libebur128,
  libmpg123,
  libogg,
  libopus,
  libvorbis,
  libvgm,
  libsndfile,
  libarchive,
  libopenmpt,
  game-music-emu,
  SDL2,
  enablePlugins ? true,
  enableVGM ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fooyin";
  version = "0-unstable-2025-05-30";

  src = fetchFromGitHub {
    owner = "ludouzi";
    repo = "fooyin";
    rev = "78b9ba1528eea485c3dde2838984b9f0a02a64fb";
    hash = "sha256-+Eo/IOyKh0CN5QuAUt9FASwZAcGCToC3Dnx6Qyi9hMU=";
  };

  buildInputs = [
    kdePackages.qcoro
    kdePackages.qtbase
    kdePackages.qtsvg
    kdePackages.qtwayland
    taglib
    ffmpeg
    kdsingleapplication
    # output plugins
    alsa-lib
    pipewire
    SDL2
    # input plugins
    flac
    libebur128
    libmpg123
    libogg
    libopus
    libvorbis
    libvgm
    libsndfile
    libarchive
    libopenmpt
    game-music-emu
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.qttools
    kdePackages.wrapQtAppsHook
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "BUILD_PLUGINS" enablePlugins)
    (lib.cmakeBool "BUILD_LIBVGM" enableVGM)
  ];

  env.LANG = "C.UTF-8";

  meta = {
    description = "Customisable music player";
    homepage = "https://www.fooyin.org/";
    downloadPage = "https://github.com/fooyin/fooyin";
    changelog = "https://github.com/fooyin/fooyin/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      peterhoeg
      keenanweaver
    ];
    mainProgram = "fooyin";
    platforms = lib.platforms.linux;
  };
})
