{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  installShellFiles,
  glew,
  glfw,
  sdl2-compat,
  libogg,
  libtheora,
  libvorbis,
  retroRevisionVer ? 3,
}:

let
  mainExecutable = if retroRevisionVer < 3 then "RSDKv5" else "RSDKv5U";
in

stdenv.mkDerivation (finalAttrs: {
  pname = "rsdkv5";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "RSDKModding";
    repo = "RSDKv5-Decompilation";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DLOnS0YzV6ETaDgPAYDqfiea8stEisrDAJTGtBZyuhg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    glew
    glfw
    sdl2-compat
    libogg
    libtheora
    libvorbis
  ];

  cmakeFlags = [
    (lib.cmakeFeature "RETRO_REVISION" (toString retroRevisionVer))
  ];

  installPhase = ''
    runHook preInstall
    installBin ${mainExecutable}
    install -Dm444 $src/LICENSE.md $out/share/licenses/RSDKv5
    runHook postInstall
  '';

  meta = {
    description = "Complete decompilation of Retro Engine (v5)";
    homepage = "https://github.com/RSDKModding/RSDKv4-Decompilation";
    license = lib.licenses.unfree; # https://github.com/RSDKModding/RSDKv4-Decompilation/blob/main/LICENSE.md
    maintainers = with lib.maintainers; [ keenanweaver ];
    mainProgram = mainExecutable;
    platforms = lib.platforms.all;
  };
})
