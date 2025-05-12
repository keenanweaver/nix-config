{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  kdePackages,
  cmake,
  ninja,
  qt6,
  procps,
  xorg,
  steam,
  useNixSteam ? true,
}:

let
  inherit (kdePackages) qtbase wrapQtAppsHook;
  qtEnv =
    with qt6;
    env "qt-env-custom-${qtbase.version}" [
      qthttpserver
      qtwebsockets
    ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "moondeck-buddy";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "FrogTheFrog";
    repo = "moondeck-buddy";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-FIb1e48SOlyJlDTIyh8HD6+veX2VfnhhQ60FMeGmOww=";
  };

  buildInputs = [
    procps
    xorg.libXrandr
    qtbase
    qtEnv
  ];
  nativeBuildInputs = [
    cmake
    ninja
    wrapQtAppsHook
  ];

  postPatch = lib.optionalString useNixSteam ''
    substituteInPlace src/lib/shared/appmetadata.cpp \
      --replace-fail /usr/bin/steam ${lib.getExe steam};
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "MoonDeckBuddy";
    description = "Helper to work with moonlight on a steamdeck";
    homepage = "https://github.com/FrogTheFrog/moondeck-buddy";
    changelog = "https://github.com/FrogTheFrog/moondeck-buddy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ redxtech ];
    platforms = lib.platforms.linux;
  };
})
