{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libogg,
  libtheora,
  glfw,
  glew,
  libGL,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sonic-mania-decompilation";
  version = "1.1.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "RSDKModding";
    repo = "Sonic-Mania-Decompilation";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-RSc9erPTG2bZ72/mKZcyXvwO3n7XO7l0fbmnXZN+ihE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libogg
    libtheora
    glfw
    glew
    libGL
  ];

  cmakeFlags = [
    (lib.cmakeBool "WITH_RSDK" true)
    (lib.cmakeBool "RETRO_MOD_LOADER" true)
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 dependencies/RSDKv5/RSDKv5U    -t $out/bin
    install -Dm755 dependencies/RSDKv5/libGame.so -t $out/lib
    patchelf --add-rpath '$ORIGIN/../lib' $out/bin/RSDKv5U

    install -Dm644 ../dependencies/RSDKv5/RSDKv5/Shaders/OGL/* \
      -t $out/share/${finalAttrs.pname}/shaders/OGL

    runHook postInstall
  '';

  meta = {
    description = "Complete decompilation of Sonic Mania (RSDKv5U engine)";
    longDescription = ''
      A reimplementation of Sonic Mania built on the decompiled RSDKv5-Ultimate
      Retro Engine, with an added mod loader. This package provides only the
      engine (RSDKv5U) and game-logic library; it cannot run without the
      original game's data files, which you must supply from a copy you own.
    '';
    homepage = "https://github.com/RSDKModding/Sonic-Mania-Decompilation";
    license = {
      fullName = "Sonic Mania Decompilation Source Code License v1";
      url = "https://github.com/RSDKModding/Sonic-Mania-Decompilation/blob/master/LICENSE.md";
      free = false;
      redistributable = true;
    };
    mainProgram = "RSDKv5U";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ keenanweaver ];
  };
})
