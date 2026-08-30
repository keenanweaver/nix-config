{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
  libxrandr,
  ninja,
  nix-update-script,
  procps,
  qt6,
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
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "FrogTheFrog";
    repo = "moondeck-buddy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kuU6bE/I3oyLUq2qFvMOzrqu5DceqxDDwP34iTLpIgI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    wrapQtAppsHook
  ];

  buildInputs = [
    procps
    libxrandr
    qtbase
    qtEnv
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Helper to work with moonlight on a steamdeck";
    homepage = "https://github.com/FrogTheFrog/moondeck-buddy";
    changelog = "https://github.com/FrogTheFrog/moondeck-buddy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ redxtech ];
    platforms = lib.platforms.linux;
    mainProgram = "MoonDeckBuddy";
  };
})
