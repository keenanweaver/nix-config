{
  lib,
  stdenv,
  fetchFromGitHub,
  sdl3,
  fluidsynth,
  libGLU,
  libpng,
  zlib,
  pkg-config,
  makeDesktopItem,
  copyDesktopItems,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "doom64ex-plus";
  version = "unstable-2025-01-18";

  src = fetchFromGitHub {
    owner = "atsb";
    repo = "Doom64EX-Plus";
    tag = "3fb15c40147f39573c676df35b6c92e6a0b82d77";
    hash = "sha256-me9rjCBNqQYFhmBsiuNko2RkVmqEs5RZoDUFshdWb6k=";
  };

  nativeBuildInputs = [
    libGLU
    pkg-config
    copyDesktopItems
    installShellFiles
  ];

  buildInputs = [
    fluidsynth
    libpng
    sdl3
    zlib
  ];

  # Can't use cmakeFlags for DOOM_UNIX_INSTALL for some reason
  env.NIX_CFLAGS_COMPILE = toString [
    "-DDOOM_UNIX_INSTALL"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "DOOM64EX-Plus";
      exec = "DOOM64EX-Plus";
      icon = "doom64ex-plus";
      desktopName = "DOOM 64 EX+";
      comment = "Improved, modern version of Doom64EX";
      categories = [ "Game" ];
    })
  ];

  installPhase = ''
    runHook preInstall
    install -Dm644 -t $out/share/icons/hicolor/256x256/apps $src/src/engine/doom64ex-plus.png
    install -Dm444 -t $out/bin $src/doom64ex-plus.wad $src/doomsnd.sf2
    install -Dm755 -t $out/bin DOOM64EX-Plus
    runHook postInstall
  '';

  postInstall = ''
    installManPage $src/doom64ex-plus.6
  '';

  meta = {
    description = "Improved, modern version of Doom64EX";
    homepage = "https://github.com/atsb/Doom64EX-Plus";
    license = lib.licenses.gpl2Only;
    longDescription = ''
      You will need DOOM64.WAD from Nightdive Studios'
      DOOM 64 Remastered release. To extract it from the GOG
      installer, run:
      ``` bash
      nix-shell -p innoextract.out --run \
      'innoextract -g /path/to/installer.exe \
      -I DOOM64.WAD -d ~/.local/share/doom64ex-plus'
      ```
    '';
    maintainers = with lib.maintainers; [ keenanweaver ];
    mainProgram = "DOOM64EX-Plus";
    platforms = lib.platforms.all;
  };
})
