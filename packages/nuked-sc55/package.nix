{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  cmake,
  ninja,
  pkg-config,
  alsa-lib,
  SDL2,
  rtmidi,
  versionCheckHook,
  nix-update-script,
}:

let
  roms = fetchzip {
    url = "https://archive.org/download/nuked-sc-55-clap-rom-files/Nuked-SC55-CLAP-ROM-files.zip";
    hash = "sha256-/wrFgtHgzsW0jDb04lYdiJRgzFvZzYvhmumsb5q79rI=";
    stripRoot = false;
  };
in

stdenv.mkDerivation {
  pname = "nuked-sc55";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "jcmoyer";
    repo = "Nuked-SC55";
    rev = "a48ef92e4bb85355a57a6ff2250d942f835f3503";
    hash = "sha256-SyEoyH0fz2GmlXWGyDGvVezK5kHFJlmsax8qWEkcp4k=";
    fetchSubmodules = true;
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    versionCheckHook
  ];

  buildInputs = [
    SDL2
    rtmidi
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ];

  doInstallCheck = true;

  cmakeFlags = [
    (lib.cmakeBool "USE_RTMIDI" (!stdenv.hostPlatform.isWindows))
  ];

  postInstall = ''
    local rombase="$out/share/nuked-sc55"
    mkdir -p "$rombase"

    for romdir in \
      ${roms}/Nuked-SC55-CLAP-ROM-files/Nuked-SC55-Resources/ROMs/* \
      ${roms}/Nuked-SC55-CLAP-ROM-files/Extras/*
    do
      local setname
      setname="$(basename "$romdir")"
      for romfile in "$romdir"/*; do
        local filename
        filename="$(basename "$romfile")"
        cp "$romfile" "$rombase/''${setname}_''${filename}"
      done
    done
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Roland SC-55 series emulation (jcmoyer fork with library backend and MIDI renderer)";
    homepage = "https://github.com/jcmoyer/Nuked-SC55";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ keenanweaver ];
    mainProgram = "nuked-sc55";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [
      fromSource # nuked-sc55
      binaryNativeCode # ROMs
    ];
  };
}
