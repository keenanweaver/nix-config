{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  glew,
  glfw,
  libGL,
  libogg,
  libtheora,
  nix-update-script,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sonic-mania-decompilation";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "RSDKModding";
    repo = "Sonic-Mania-Decompilation";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RSc9erPTG2bZ72/mKZcyXvwO3n7XO7l0fbmnXZN+ihE=";
    fetchSubmodules = true;
  };

  __structuredAttrs = true;
  strictDeps = true;

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

  passthru.updateScript = nix-update-script { };

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
      free = false;
      fullName = "Sonic Mania Decompilation Source Code License v1";
      redistributable = true;
      url = "https://github.com/RSDKModding/Sonic-Mania-Decompilation/blob/master/LICENSE.md";
    };

    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.linux;
    mainProgram = "RSDKv5U";
  };
})
