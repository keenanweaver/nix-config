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
  nix-update-script,
  pkg-config,
  rhash,
  tinyxml-2,
  versionCheckHook,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lgogdownloader";
  version = "3.18";

  src = fetchFromGitHub {
    owner = "Sude-";
    repo = "lgogdownloader";
    rev = "332e2afbb7fd384299e6f8f58eff916c4327c7cc";
    hash = "sha256-n32dFqHGQlTXjsPvq8Uwae53YNsCOA6icHMaTUbmbbo=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    help2man
  ];

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
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-DJSONCPP_HAS_STRING_VIEW=1")
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  preVersionCheck = ''
    export HOME=$(mktemp -d)
  '';

  versionCheckKeepEnvironment = [ "HOME" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--flake"
      "--version=branch"
    ];
  };

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

    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "lgogdownloader";
  };
})
