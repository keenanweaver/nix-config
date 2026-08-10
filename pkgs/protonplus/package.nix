{
  lib,
  stdenv,
  fetchFromGitHub,
  appstream,
  desktop-file-utils,
  glib,
  glib-networking,
  gtk4,
  json-glib,
  libadwaita,
  libarchive,
  libgee,
  libnotify,
  libsoup_3,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  sdl3,
  vala,
  wrapGAppsHook4,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "protonplus";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "Vysp3r";
    repo = "protonplus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xNuPseGQqypM8sYxwIEkrbCDGScrE7eWRy1f+IOErO0=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    glib-networking
    gtk4
    json-glib
    libadwaita
    libarchive
    libgee
    libsoup_3
    appstream
    sdl3
    libnotify
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Simple Wine and Proton-based compatibility tools manager";
    homepage = "https://github.com/Vysp3r/ProtonPlus";
    changelog = "https://github.com/Vysp3r/ProtonPlus/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ getchoo ];
    platforms = lib.platforms.linux;
    mainProgram = "protonplus";
  };
})
