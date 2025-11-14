{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  installShellFiles,
  glew,
  sdl2-compat,
  libogg,
  libvorbis,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rsdkv4";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "RSDKModding";
    repo = "RSDKv4-Decompilation";
    tag = finalAttrs.version;
    hash = "sha256-JRnf7Ubtdr62wdgMlf6DVVykUh3BlHU/hZ/Zf7Bbi4o=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    glew
    sdl2-compat
    libogg
    libvorbis
  ];

  installPhase = ''
    runHook preInstall

    installBin RSDKv4
    install -Dm444 $src/LICENSE.md $out/share/licenses/RSDKv4

    runHook postInstall
  '';

  meta = {
    description = "Complete decompilation of Sonic 1 & Sonic 2 (2013) & Retro Engine (v4)";
    homepage = "https://github.com/RSDKModding/RSDKv4-Decompilation";
    license = lib.licenses.unfree; # https://github.com/RSDKModding/RSDKv4-Decompilation/blob/main/LICENSE.md
    maintainers = with lib.maintainers; [ keenanweaver ];
    mainProgram = "RSDKv4";
    platforms = lib.platforms.all;
  };
})
