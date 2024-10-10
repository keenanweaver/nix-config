{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  git,
  SDL2,
  SDL2_mixer,
  unstableGitUpdater,
  buildOpenGLES ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rigel-engine";
  version = "0-unstable-2024-05-26";

  src = fetchFromGitHub {
    owner = "lethal-guitar";
    repo = "RigelEngine";
    rev = "f05996f9b3ad3b3ea5bb818e49e7977636746343";
    hash = "sha256-iZ+eYZxnVqHo4vLeZdoV7TO3fWivCfbAf4F57/fU7aY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    git
    SDL2
    SDL2_mixer
  ];

  cmakeFlags = [
    "-Wno-dev"
  ] ++ lib.optional buildOpenGLES "-DUSE_GL_ES=ON";

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Modern re-implementation of the classic DOS game Duke Nukem II";
    homepage = "https://github.com/lethal-guitar/RigelEngine";
    license = lib.licenses.gpl2Only;
    longDescription = ''
      RigelEngine requires the game data files to run. To extract them from the Zoom Platform installer, run:
      ``` bash
      nix-shell -p innoextract.out --run \
      "innoextract /path/to/installer.exe \
      -I 'NUKEM2.CMP' -I 'NUKEM2.F1' -I 'NUKEM2.F2' \
      -I 'NUKEM2.F3' -I 'NUKEM2.F4' -I 'NUKEM2.F5' \
      -d ~/Games/duke-nukem-ii"
      ```
    '';
    maintainers = with lib.maintainers; [ keenanweaver ];
    mainProgram = "RigelEngine";
    platforms = lib.platforms.all;
  };
})
