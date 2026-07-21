{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  glew,
  installShellFiles,
  libogg,
  libtheora,
  libvorbis,
  pkg-config,
  sdl2-compat,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rsdkv3";
  version = "1.3.3";
  src = fetchFromGitHub {
    owner = "RSDKModding";
    repo = "RSDKv3-Decompilation";
    tag = finalAttrs.version;
    hash = "sha256-M7AABw9fK4crJqIvpL+KGDlVa0eN+ZouRqC9oEBWRIA=";
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
    libtheora
    libvorbis
  ];
  installPhase = ''
    runHook preInstall

    installBin RSDKv3
    install -Dm444 $src/LICENSE.md $out/share/licenses/RSDKv3

    runHook postInstall
  '';
  meta = {
    description = "Full Decompilation of Sonic CD (2011) & Retro Engine (v3)";
    homepage = "https://github.com/RSDKModding/RSDKv3-Decompilation";
    license = lib.licenses.unfree; # https://github.com/RSDKModding/RSDKv3-Decompilation/blob/main/LICENSE.md
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.all;
    mainProgram = "RSDKv3";
  };
})
