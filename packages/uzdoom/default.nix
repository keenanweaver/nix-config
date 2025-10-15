{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  SDL2,
  bzip2,
  cmake,
  game-music-emu,
  gtk3,
  imagemagick,
  libGL,
  libjpeg,
  libvpx,
  libwebp,
  ninja,
  openal,
  pkg-config,
  vulkan-loader,
  zlib,
  zmusic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uzdoom";
  version = "4.14.2-unstable-2025-10-14";

  src = fetchFromGitHub {
    owner = "UZDoom";
    repo = "UZDoom";
    rev = "4103aebeeb707fd7293a1677ace58bfb813259e5";
    fetchSubmodules = true;
    hash = "sha256-1GbjtfVqSi1/tX4VEd4nUM+np0IoOecbbOE2qpaKxv4=";
  };

  outputs = [ "out" ] ++ lib.optionals stdenv.hostPlatform.isLinux [ "doc" ];

  nativeBuildInputs = [
    cmake
    imagemagick
    makeWrapper
    ninja
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ copyDesktopItems ];

  buildInputs = [
    SDL2
    zlib
    bzip2
    gtk3

    # Graphics
    libGL
    libjpeg
    libvpx
    libwebp
    vulkan-loader

    # Sound (ZMusic contain MIDI libs)
    game-music-emu
    openal
    zmusic
  ];

  postPatch = ''
    substituteInPlace tools/updaterevision/UpdateRevision.cmake \
      --replace-fail "ret_var(Tag)" "ret_var(\"${finalAttrs.src.rev}\")" \
      --replace-fail "ret_var(Timestamp)" "ret_var(\"1970-00-00 00:00:00 +0000\")" \
      --replace-fail "ret_var(Hash)" "ret_var(\"${finalAttrs.src.rev}\")" \
      --replace-fail "<unknown version>" "${finalAttrs.src.rev}"
  '';

  # Apple dropped GL support
  # Shader's loading will throw an error while linking
  cmakeFlags = [
    (lib.cmakeBool "DYN_GTK" false)
    (lib.cmakeBool "DYN_OPENAL" false)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ (lib.cmakeBool "HAVE_GLES2" false) ];

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "uzdoom";
      exec = "uzdoom";
      desktopName = "uzdoom";
      comment = finalAttrs.meta.description;
      icon = "gzdoom";
      categories = [ "Game" ];
    })
  ];

  installPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications"
    mv gzdoom.app "$out/Applications/uzdoom.app"
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    mv $out/bin/gzdoom $out/share/games/doom/uzdoom
    makeWrapper $out/share/games/doom/uzdoom $out/bin/uzdoom \
      --set LD_LIBRARY_PATH ${lib.makeLibraryPath [ vulkan-loader ]}

    for size in 16 24 32 48 64 128; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      magick $src/src/win32/icon1.ico -background none -resize "$size"x"$size" -flatten \
       $out/share/icons/hicolor/"$size"x"$size"/apps/gzdoom.png
    done;
  '';

  meta = {
    homepage = "https://github.com/UZDoom/UZDoom";
    description = "Modder-friendly OpenGL and Vulkan source port based on the DOOM engine";
    mainProgram = "uzdoom";
    longDescription = ''
      uzdoom is a feature centric port for all DOOM engine games, based on
      ZDoom, adding an OpenGL renderer and powerful scripting capabilities.
    '';
    license = lib.licenses.gpl3Plus;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [
      azahi
      lassulus
      Gliczy
      r4v3n6101
    ];
  };
})
