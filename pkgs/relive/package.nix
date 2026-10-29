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
  version = "appveyor_4227-unstable-2026-10-26";

  src = fetchFromGitHub {
    owner = "AliveTeam";
    repo = "alive_reversing";
    rev = "fe6f54c4b349f344fccd1bc0bf0839ee58db7e34";
    hash = "sha256-3RtvDVfzvzYuiFh4ywBQ6E/S74FL22tQ1vrhu9fhM+4=";
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
