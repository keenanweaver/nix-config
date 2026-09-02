{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fluidsynth,
  glew,
  libX11,
  libXext,
  libXinerama,
  libXrandr,
  nix-update-script,
  sdl3,
  zenity,
}:

stdenv.mkDerivation {
  pname = "relive";
  version = "appveyor_4227-unstable-2026-09-01";

  src = fetchFromGitHub {
    owner = "AliveTeam";
    repo = "alive_reversing";
    rev = "3be8967b71b29e6e61009d291bd64dce39abf7ac";
    hash = "sha256-SZwy3whmnvqe6yXUSN2wcPmKeUVfuNg++Fx685aXf/U=";
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
    sdl3
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
