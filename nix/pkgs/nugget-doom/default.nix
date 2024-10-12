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
  pname = "nugget-doom";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "MrAlaux";
    repo = "Nugget-Doom";
    rev = "nugget-doom-${finalAttrs.version}";
    hash = "sha256-X0LQfoCXtIYtxPdJBMphZreo7RwF6cKUQSw7f0yUUgY=";
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
    description = "Nugget Doom is a fork of Woof! with additional features";
    homepage = "https://github.com/MrAlaux/Nugget-Doom";
    changelog = "https://github.com/MrAlaux/Nugget-Doom/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ keenanweaver ];
    mainProgram = "nugget-doom";
    platforms = with lib.platforms; darwin ++ linux ++ windows;
  };
})
