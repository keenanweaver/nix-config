{
  lib,
  stdenv,
  fetchgit,
  pkg-config,
  meson,
  ninja,
  makeWrapper,
  gpu-screen-recorder,
  gpu-screen-recorder-notification,
  libX11,
  libXrender,
  libXrandr,
  libXcomposite,
  libXi,
  libXcursor,
  libglvnd,
  wrapperDir ? "/run/wrappers/bin",
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "gpu-screen-recorder-ui";
  version = "1.1.7";

  src = fetchgit {
    url = "https://repo.dec05eba.com/${pname}";
    rev = version;
    hash = "sha256-8KBBuZhb5e/Xh2MwxHSVXLETQz9Koi+0IEdp2adp0aM=";
  };

  postPatch = ''
    substituteInPlace depends/mglpp/depends/mgl/src/gl.c \
      --replace-fail "libGL.so.1" "${lib.getLib libglvnd}/lib/libGL.so.1" \
      --replace-fail "libGLX.so.0" "${lib.getLib libglvnd}/lib/libGLX.so.0" \
      --replace-fail "libEGL.so.1" "${lib.getLib libglvnd}/lib/libEGL.so.1"

    substituteInPlace extra/gpu-screen-recorder-ui.service \
      --replace-fail "ExecStart=${meta.mainProgram}" "ExecStart=$out/bin/${meta.mainProgram}"
  '';

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    makeWrapper
  ];

  buildInputs = [
    libX11
    libXrender
    libXrandr
    libXcomposite
    libXi
    libXcursor
    libglvnd
  ];

  mesonFlags = [
    # Handled by the module
    (lib.mesonBool "capabilities" false)
  ];

  postInstall =
    let
      gpu-screen-recorder-wrapped = gpu-screen-recorder.override {
        inherit wrapperDir;
      };
    in
    ''
      wrapProgram "$out/bin/${meta.mainProgram}" \
        --prefix PATH : "${wrapperDir}" \
        --suffix PATH : "${
          lib.makeBinPath [
            gpu-screen-recorder-wrapped
            gpu-screen-recorder-notification
          ]
        }"
    '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "A fullscreen overlay UI for GPU Screen Recorder in the style of ShadowPlay";
    homepage = "https://git.dec05eba.com/${pname}/about/";
    license = lib.licenses.gpl3Only;
    mainProgram = "gsr-ui";
    maintainers = with lib.maintainers; [ js6pak ];
    platforms = lib.platforms.linux;
  };
}