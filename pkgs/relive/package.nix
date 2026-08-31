{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  cmake,
  fluidsynth,
  glew,
  libX11,
  libXext,
  libXinerama,
  libXrandr,
  nix-update-script,
  zenity,
}:

stdenv.mkDerivation {
  pname = "relive";
  version = "appveyor_4227-unstable-2026-08-14";

  src = fetchFromGitHub {
    owner = "AliveTeam";
    repo = "alive_reversing";
    rev = "4443c56338d1091894ac1be5e068a77c2ba92763";
    hash = "sha256-hB/XtHoI3UxIJDYWkLstj/RqfQFJ7TLRV+0efvoStSU=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace assets/relive-ao assets/relive-ae \
      --replace-fail "zenity" "${lib.getExe' zenity "zenity"}" \
      --replace-fail "  relive" "  $out/bin/relive"
    substituteInPlace assets/relive-ao.desktop assets/relive-ae.desktop \
      --replace-fail "/usr/bin" "$out/bin"
  '';

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

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--flake"
      "--version=branch"
    ];
  };

  meta = {
    description = "Re-implementation of Oddworld: Abe's Exoddus and Oddworld: Abe's Oddysee";
    homepage = "https://github.com/AliveTeam/alive_reversing";
    license = lib.licenses.mit;

    maintainers = with lib.maintainers; [
      ByteSudoer
      keenanweaver
    ];

    mainProgram = "relive";
  };
}
