{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  alsa-lib,
  cmake,
  ffmpeg,
  game-music-emu,
  icu,
  kdsingleapplication,
  libarchive,
  libebur128,
  libopenmpt,
  libsndfile,
  libvgm,
  nix-update-script,
  pipewire,
  pkg-config,
  qt6Packages,
  soundtouch,
  soxr,
  taglib,
  versionCheckHook,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fooyin";
  version = "0.11.1";
  __structuredAttrs = true;
  strictDeps = true;
  src = fetchFromGitHub {
    owner = "ludouzi";
    repo = "fooyin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-228hxjKkxE0ILzP8dnIS21R3AW9Y0+wutgcYlQdCgXc=";
  };
  nativeBuildInputs = [
    cmake
    pkg-config
    qt6Packages.qttools
    qt6Packages.wrapQtAppsHook
    versionCheckHook
  ];
  buildInputs = [
    qt6Packages.qcoro
    qt6Packages.qtbase
    qt6Packages.qtsvg
    qt6Packages.qtwayland
    taglib
    ffmpeg
    icu
    kdsingleapplication
    soundtouch
    soxr
    zlib
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
  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
    # INSTALL_FHS must be true so build artifacts land in well-known paths;
    # fixupPhase handles the rest
    (lib.cmakeBool "INSTALL_FHS" true)
  ];
  env.LANG = "C.UTF-8";
  doInstallCheck = true;
  passthru.updateScript = nix-update-script { };
  meta = {
    description = "Customisable music player";
    homepage = "https://www.fooyin.org/";
    changelog = "https://github.com/fooyin/fooyin/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.linux;
    mainProgram = "fooyin";
    downloadPage = "https://github.com/fooyin/fooyin/releases";
  };
})
