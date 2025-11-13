{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  fluidsynth,
  glew,
  zenity,
  libX11,
  libXrandr,
  libXinerama,
  libXext,
  SDL2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "relive";
  version = "1.0.9-unstable-05-29-2025";

  src = fetchFromGitHub {
    owner = "AliveTeam";
    repo = "alive_reversing";
    rev = "7bf8a75de37f6f65554bf1c4a0e4b1100f0d37ae";
    hash = "sha256-w/mpu9bE+jHbRDyE5Oy47EDQd/FXfwjXqndSBe7XKC4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    fluidsynth
    glew
    libX11
    libXrandr
    libXinerama
    libXext
    SDL2
    zenity
  ];

  postPatch = ''
    substituteInPlace assets/relive-ao assets/relive-ae \
      --replace-fail "zenity" "${lib.getExe' zenity "zenity"}" \
      --replace-fail "  relive" "  $out/bin/relive"
    substituteInPlace assets/relive-ao.desktop assets/relive-ae.desktop \
      --replace-fail "/usr/bin" "$out/bin"
  '';

  meta = {
    description = "Re-implementation of Oddworld: Abe's Exoddus and Oddworld: Abe's Oddysee";
    homepage = "https://github.com/AliveTeam/alive_reversing";
    maintainers = with lib.maintainers; [
      ByteSudoer
      keenanweaver
    ];
    license = lib.licenses.mit;
    mainProgram = "relive";
  };
})
