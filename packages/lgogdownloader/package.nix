{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  cmake,
  curl,
  help2man,
  html-tidy,
  htmlcxx,
  jsoncpp,
  liboauth,
  ninja,
  pkg-config,
  qt6,
  rhash,
  tinyxml-2,
  versionCheckHook,
  zlib,
  enableGui ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lgogdownloader";
  version = "3.18";
  __structuredAttrs = true;
  strictDeps = true;
  src = fetchFromGitHub {
    owner = "Sude-";
    repo = "lgogdownloader";
    rev = "cc2c4530159f79c17ac2905c603e12af9889d216";
    hash = "sha256-2rtRyUStbkADP0ioJ49oFH3b41TsDst7jmguQRqbTa0=";
  };
  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    help2man
  ]
  ++ lib.optional enableGui qt6.wrapQtAppsHook;
  buildInputs = [
    boost
    curl
    html-tidy
    htmlcxx
    jsoncpp
    liboauth
    rhash
    tinyxml-2
    zlib
  ]
  ++ lib.optionals enableGui [
    qt6.qtbase
    qt6.qtwebengine
  ];
  cmakeFlags = [
    (lib.cmakeBool "USE_QT_GUI" enableGui)
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-DJSONCPP_HAS_STRING_VIEW=1")
  ];
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  preVersionCheck = ''
    export HOME=$(mktemp -d)
  '';
  versionCheckKeepEnvironment = [ "HOME" ];
  meta = {
    description = "Unofficial downloader to GOG.com for Linux users. It uses the same API as the official GOGDownloader";
    homepage = "https://github.com/Sude-/lgogdownloader";
    changelog = "https://github.com/Sude-/lgogdownloader/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.wtfpl;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [
      _0x4A6F
      keenanweaver
    ];
    platforms = lib.platforms.linux ++ lib.optionals (!enableGui) lib.platforms.darwin;
    mainProgram = "lgogdownloader";
  };
})
