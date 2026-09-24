{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  cmake,
  fetchzip,
  ninja,
  nix-update-script,
  pkg-config,
  rtmidi,
  sdl2-compat,
  versionCheckHook,
}:

let
  roms = fetchzip {
    hash = "sha256-/wrFgtHgzsW0jDb04lYdiJRgzFvZzYvhmumsb5q79rI=";
    stripRoot = false;
    url = "https://archive.org/download/nuked-sc-55-clap-rom-files/Nuked-SC55-CLAP-ROM-files.zip";
  };
in

stdenv.mkDerivation {
  pname = "nuked-sc55";
  version = "0.6.1-unstable-2026-09-23";

  src = fetchFromGitHub {
    owner = "jcmoyer";
    repo = "Nuked-SC55";
    rev = "d81c68f634b1025c39d8003edca372451add9424";
    hash = "sha256-JhzvmJA9ZRfQoxXS5M6eMXrJoxNWOtJ474Yv0dvmbqI=";
    fetchSubmodules = true;
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    versionCheckHook
  ];

  buildInputs = [
    sdl2-compat
    rtmidi
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ];

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
    extraArgs = [
      "--flake"
      "--version=branch"
    ];
  };

  meta = {
    description = "Roland SC-55 series emulation (jcmoyer fork with library backend and MIDI renderer)";
    homepage = "https://github.com/jcmoyer/Nuked-SC55";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [
      fromSource # nuked-sc55
      binaryNativeCode # ROMs
    ];
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "nuked-sc55";
  };
}
