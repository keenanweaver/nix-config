{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  cmake,
  copyDesktopItems,
  libX11,
  makeDesktopItem,
  nix-update-script,
  versionCheckHook,
}:

let
  imgui-src = fetchFromGitHub {
    hash = "sha256-+BuSAXvLvOYOmENzxd1pGDE6llWhTGVu7C3RnoVLVzg=";
    owner = "ocornut";
    repo = "imgui";
    tag = "v1.91.8";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "crusader-no-remorse-decomp";
  version = "1.35.9";

  src = fetchFromGitHub {
    owner = "sebsebseb1982";
    repo = "crusader-no-remorse-decomp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J39c6/OB93SSYy3NOacf3vqEkn+NUE/PLfOZ+kTDnXU=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    copyDesktopItems
  ];

  buildInputs = [
    SDL2
    libX11
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CRUSADER_VERSION" finalAttrs.version)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_IMGUI" "${imgui-src}")
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
  ];

  doCheck = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 crusader crusader-editor -t $out/bin
    install -Dm444 $src/icon.png $out/share/pixmaps/crusader.png

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  desktopItems = [
    (makeDesktopItem {
      name = "crusader";

      categories = [
        "Game"
        "ActionGame"
      ];

      comment = finalAttrs.meta.description;
      desktopName = "Crusader: No Remorse";
      exec = "crusader";
      icon = "crusader";
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Reimplementation of the Crusader: No Remorse engine";
    homepage = "https://github.com/sebsebseb1982/crusader-no-remorse-decomp";
    changelog = "https://github.com/sebsebseb1982/crusader-no-remorse-decomp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.linux;
    mainProgram = "crusader";
  };
})
