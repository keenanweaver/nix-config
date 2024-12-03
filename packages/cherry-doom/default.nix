{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  SDL2,
  SDL2_net,
  openal,
  libsndfile,
  fluidsynth,
  alsa-lib,
  libxmp,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cherry-doom";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "xemonix0";
    repo = "Cherry-Doom";
    rev = "cherry-doom-${finalAttrs.version}";
    hash = "sha256-f/5b4i5omCp34upJ2/VF7VuvwU9YliXcWnyR4jl9gKA=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  buildInputs = [
    SDL2
    SDL2_net
    alsa-lib
    fluidsynth
    libsndfile
    libxmp
    openal
  ];

  meta = {
    description = "Cherry Doom is a fork of Nugget Doom with more additional features";
    homepage = "https://github.com/xemonix0/Cherry-Doom";
    changelog = "https://github.com/xemonix0/Cherry-Doom/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ keenanweaver ];
    mainProgram = "cherry-doom";
    platforms = with lib.platforms; darwin ++ linux ++ windows;
  };
})
