{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  kdePackages,
  qtPackages ? kdePackages,
}:
let
  qtMajorVersion = lib.versions.major qtPackages.qtbase.version;
  qtVersionSpecificBuildInputs =
    with qtPackages;
    {
      "5" = [
        qtx11extras
        kconfigwidgets
        kirigami2
      ];
      "6" = [
        qtsvg
        kcolorscheme
        kconfig
        kcoreaddons
        kdecoration
        kguiaddons
        ki18n
        kirigami
        kwidgetsaddons
      ];
    }
    .${qtMajorVersion};
in
stdenv.mkDerivation (finalAttrs: {
  pname = "klassy-qt${qtMajorVersion}";
  version = "6.2.breeze6.2.1";

  src = fetchFromGitHub {
    owner = "paulmcauley";
    repo = "klassy";
    tag = finalAttrs.version;
    hash = "sha256-tFqze3xN1XECY74Gj0nScis7DVNOZO4wcfeA7mNZT5M=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    qtPackages.extra-cmake-modules
    qtPackages.wrapQtAppsHook
  ];

  buildInputs =
    with qtPackages;
    [
      qtbase
      qtdeclarative
      qttools

      frameworkintegration
      kcmutils
      kdecoration
      kiconthemes
      kwindowsystem
    ]
    ++ qtVersionSpecificBuildInputs;

  cmakeFlags = map (v: lib.cmakeBool "BUILD_QT${v}" (v == qtMajorVersion)) [
    "5"
    "6"
  ];

  meta =
    {
      description = "Highly customizable binary Window Decoration, Application Style and Global Theme plugin for recent versions of the KDE Plasma desktop";
      homepage = "https://github.com/paulmcauley/klassy";
      platforms = lib.platforms.linux;
      license = with lib.licenses; [
        bsd3
        cc0
        gpl2Only
        gpl2Plus
        gpl3Only
        gpl3Plus # KDE-Accepted-GPL
        mit
      ];
      maintainers = with lib.maintainers; [ pluiedev ];
    }
    // lib.optionalAttrs (qtMajorVersion == "6") {
      mainProgram = "klassy-settings";
    };
})
