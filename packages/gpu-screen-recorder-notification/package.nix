{
  lib,
  stdenv,
  fetchgit,
  gitUpdater,
  gsettings-desktop-schemas,
  libglvnd,
  libx11,
  libxext,
  libxkbcommon,
  libxrandr,
  libxrender,
  makeWrapper,
  meson,
  ninja,
  pango,
  pkg-config,
  wayland,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpu-screen-recorder-notification";
  version = "1.3.3";
  __structuredAttrs = true;
  strictDeps = true;
  src = fetchgit {
    url = "https://repo.dec05eba.com/gpu-screen-recorder-notification";
    tag = finalAttrs.version;
    hash = "sha256-ejAdrqmZYncTxACJNrP3vSx83KygaV3HdR4kAM5wfN0=";
  };
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    makeWrapper
  ];
  buildInputs = [
    libglvnd
    pango
    libx11
    libxrandr
    libxrender
    libxkbcommon
    libxext
    wayland
    wayland-scanner
    gsettings-desktop-schemas
  ];
  postInstall = ''
    wrapProgram "$out/bin/${finalAttrs.meta.mainProgram}" \
      --prefix XDG_DATA_DIRS : "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libglvnd ]}"
  '';
  mesonBuildType = "release";
  passthru.updateScript = gitUpdater { };
  meta = {
    description = "Notification in the style of ShadowPlay";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder-notification/about";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [
      AhmedAmr
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "gsr-notify";
  };
})
