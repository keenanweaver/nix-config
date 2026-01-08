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
  icu,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fooyin";
  version = "0.9.2-unstable-01-01-2026";

  src = fetchFromGitHub {
    owner = "ludouzi";
    repo = "fooyin";
    rev = "fccda648399f37d94423225da26f18773e706aeb";
    hash = "sha256-6jcDkceTPVU4HSUy7f/hL4pcOK2mwXF3Q5UiMjOjLVk=";
  };

  buildInputs = [
    kdePackages.qcoro
    kdePackages.qtbase
    kdePackages.qtsvg
    kdePackages.qtwayland
    taglib
    ffmpeg
    icu
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
    # we need INSTALL_FHS to be true as the various artifacts are otherwise just dumped in the root
    # of $out and the fixupPhase cleans things up anyway
    (lib.cmakeBool "INSTALL_FHS" true)
  ];

  env.LANG = "C.UTF-8";

  meta = {
    description = "Customisable music player";
    homepage = "https://www.fooyin.org/";
    changelog = "https://github.com/fooyin/fooyin/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    downloadPage = "https://github.com/fooyin/fooyin";
    mainProgram = "fooyin";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.linux;
  };
})