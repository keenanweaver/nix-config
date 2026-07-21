{
  lib,
  stdenv,
  addDriverRunpath,
  dbus,
  fetchgit,
  ffmpeg,
  gitUpdater,
  libcap,
  libdrm,
  libglvnd,
  libjpeg_turbo,
  libpulseaudio,
  libva,
  libxcomposite,
  libxdamage,
  libxfixes,
  libxi,
  libxrandr,
  makeWrapper,
  meson,
  ninja,
  pipewire,
  pkg-config,
  vulkan-headers,
  vulkan-loader,
  wayland,
  wayland-scanner,
  wrapperDir ? "/run/wrappers/bin",
}:

stdenv.mkDerivation rec {
  pname = "gpu-screen-recorder";
  version = "5.15.1";
  src = fetchgit {
    url = "https://repo.dec05eba.com/${pname}";
    tag = version;
    hash = "sha256-nYkol0bidSwjSJIsBYsT0BE8ouMmOActWQZQCOsJvw8=";
  };
  postPatch = ''
    substituteInPlace src/capture/v4l2.c \
      --replace-fail "libturbojpeg.so.0" "${lib.getLib libjpeg_turbo}/lib/libturbojpeg.so.0"
  '';
  nativeBuildInputs = [
    pkg-config
    makeWrapper
    meson
    ninja
  ];
  buildInputs = [
    libxcomposite
    libcap
    libpulseaudio
    dbus
    ffmpeg
    pipewire
    wayland
    wayland-scanner
    vulkan-loader
    vulkan-headers
    libdrm
    libva
    libxdamage
    libxi
    libxrandr
    libxfixes
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
    maintainers = with lib.maintainers; [
      babbaj
      js6pak
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "gpu-screen-recorder";
  };
}
