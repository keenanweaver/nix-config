{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsa-lib,
  ffmpeg,
  kdePackages,
  kdsingleapplication,
  pipewire,
  taglib,
  libebur128,
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
  version = "0-unstable-2025-06-22";

  src = fetchFromGitHub {
    owner = "ludouzi";
    repo = "fooyin";
    rev = "8303633a2d11bad54ab54d2b64b31ca03bac6ab3";
    hash = "sha256-eC9ES5FYiZRjTkjCJ24nYJW3RwLmPGUiSMRw+OFFL1I=";
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
    libebur128
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
