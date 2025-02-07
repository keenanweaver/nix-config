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
  libebur128,
  python3,
  yyjson,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nugget-doom";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "MrAlaux";
    repo = "Nugget-Doom";
    rev = "nugget-doom-${finalAttrs.version}";
    hash = "sha256-Ros31NPs0GKbAt2cI18Ue4uKPUh1e2vMjL7Wa0+YaHQ=";
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
    libebur128
    openal
    yyjson
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nugget Doom is a fork of Woof! with additional features";
    homepage = "https://github.com/MrAlaux/Nugget-Doom";
    changelog = "https://github.com/MrAlaux/Nugget-Doom/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ keenanweaver ];
    mainProgram = "nugget-doom";
    platforms = lib.platforms.all;
  };
})
