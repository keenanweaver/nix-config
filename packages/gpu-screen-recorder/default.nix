{
  stdenv,
  lib,
  fetchurl,
  makeWrapper,
  meson,
  ninja,
  addDriverRunpath,
  pkg-config,
  libXcomposite,
  libpulseaudio,
  dbus,
  ffmpeg,
  wayland,
  wayland-scanner,
  vulkan-headers,
  pipewire,
  libdrm,
  libva,
  libglvnd,
  libXdamage,
  libXi,
  libXrandr,
  libXfixes,
  wrapperDir ? "/run/wrappers/bin",
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpu-screen-recorder";
  version = "5.3.8";

  src = fetchurl {
    url = "https://dec05eba.com/snapshot/gpu-screen-recorder.git.${finalAttrs.version}.tar.gz";
    hash = "sha256-SBW+B57bSKqQFuF7TK3PiRT+zODVlAnq0+sjv3/rsP0=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    meson
    ninja
  ];

  buildInputs = [
    libXcomposite
    libpulseaudio
    dbus
    ffmpeg
    pipewire
    wayland
    wayland-scanner
    vulkan-headers
    libdrm
    libva
    libXdamage
    libXi
    libXrandr
    libXfixes
  ];

  mesonFlags = [
    # Install the upstream systemd unit
    (lib.mesonBool "systemd" true)
    # Enable Wayland support
    (lib.mesonBool "portal" true)
    # Handle by the module
    (lib.mesonBool "capabilities" false)
    (lib.mesonBool "nvidia_suspend_fix" false)
  ];

  postPatch = ''
    substituteInPlace extra/gpu-screen-recorder.service \
      --replace-fail "ExecStart=gpu-screen-recorder" "ExecStart=$out/bin/gpu-screen-recorder"
  '';

  postInstall = ''
    mkdir $out/bin/.wrapped
    mv $out/bin/gpu-screen-recorder $out/bin/.wrapped/
    makeWrapper "$out/bin/.wrapped/gpu-screen-recorder" "$out/bin/gpu-screen-recorder" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libglvnd
          addDriverRunpath.driverLink
        ]
      }" \
      --prefix PATH : "${wrapperDir}" \
      --suffix PATH : "$out/bin"
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Screen recorder that has minimal impact on system performance by recording a window using the GPU only";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder/about/";
    license = lib.licenses.gpl3Only;
    mainProgram = "gpu-screen-recorder";
    maintainers = [ lib.maintainers.babbaj ];
    platforms = [ "x86_64-linux" ];
  };
})
