{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  glew,
  sdl2-compat,
  libvorbis,
  libXcursor,
  libXrandr,
  libXext,
  libXScrnSaver,
  libXi,
  libXfixes,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "RSDKv4";
  version = "0-unstable-2025-07-25";

  src = fetchFromGitHub {
    owner = "Rubberduckycooly";
    repo = "Sonic-1-2-2013-Decompilation";
    rev = "3a7168f179e0587526e719d1ac2a8c91138901b8";
    hash = "sha256-DwmISe/WwsWp9IWLTGGCODAe5mlm294FKKwaPyZDe28=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace RSDKv4/RetroEngine.hpp \
      --replace-fail '#include <SDL.h>' '#include <SDL2/SDL.h>'
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glew
    sdl2-compat
    libvorbis
    libXcursor
    libXext
    libXScrnSaver
    libXrandr
    libXi
    libXfixes
  ];

  installFlags = [ "prefix=$(out)" ];

  meta = {
    description = "Complete decompilation of Sonic 1 & Sonic 2 (2013) & Retro Engine (v4)";
    homepage = "https://github.com/Rubberduckycooly/Sonic-1-2-2013-Decompilation";
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ puffnfresh ];
    platforms = lib.platforms.linux;
  };
})
