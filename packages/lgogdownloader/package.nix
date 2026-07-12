{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  curl,
  boost,
  liboauth,
  jsoncpp,
  htmlcxx,
  rhash,
  tinyxml-2,
  help2man,
  html-tidy,
  qt6,
  zlib,
  versionCheckHook,

  enableGui ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lgogdownloader";
  version = "3.18";

  strictDeps = true;
  __structuredAttrs = true;

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

  preVersionCheck = ''
    export HOME=$(mktemp -d)
  '';
  versionCheckKeepEnvironment = [ "HOME" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Unofficial downloader to GOG.com for Linux users. It uses the same API as the official GOGDownloader";
    mainProgram = "lgogdownloader";
    homepage = "https://github.com/Sude-/lgogdownloader";
    changelog = "https://github.com/Sude-/lgogdownloader/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.wtfpl;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    platforms = lib.platforms.linux ++ lib.optionals (!enableGui) lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      _0x4A6F
      keenanweaver
    ];
  };
})
