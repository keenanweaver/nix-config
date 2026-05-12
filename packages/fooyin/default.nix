{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6Packages,
  taglib,
  ffmpeg,
  icu,
  zlib,
  alsa-lib,
  pipewire,
  SDL2,
  kdsingleapplication,
  libsndfile,
  libopenmpt,
  game-music-emu,
  libarchive,
  libebur128,
  soundtouch,
  soxr,
  #libvgm,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fooyin";
  version = "0.10.6";

  src = fetchFromGitHub {
    owner = "ludouzi";
    repo = "fooyin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TiAeSPTzDWmEallyeeq02faVdDCpPDZoJsm9FF4orY8=";
  };

  __structuredAttrs = true;
  strictDeps = true;

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
    #libvgm
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
    downloadPage = "https://github.com/fooyin/fooyin/releases";
    mainProgram = "fooyin";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
