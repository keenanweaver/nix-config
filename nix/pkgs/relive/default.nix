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
  version = "1.0.4687";

  src = fetchFromGitHub {
    owner = "AliveTeam";
    repo = "alive_reversing";
    rev = "appveyor_${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-4dZ4efxqdK/MJauQwQVBiz/AeqeCnEDNYwOKbDzU1gY=";
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
