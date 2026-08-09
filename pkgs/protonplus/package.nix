{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  desktop-file-utils,
  wrapGAppsHook4,
  meson,
  ninja,
  pkg-config,
  vala,
  glib,
  glib-networking,
  gtk4,
  json-glib,
  libadwaita,
  libarchive,
  libgee,
  libsoup_3,
  appstream,
  libnotify,
  sdl3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "protonplus";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "Vysp3r";
    repo = "protonplus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YkoWKUeAG5ZUqs42sHYT5+tj7JKvYm9q3LodPs2RQos=";
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
    mainProgram = "protonplus";
    description = "Simple Wine and Proton-based compatibility tools manager";
    homepage = "https://github.com/Vysp3r/ProtonPlus";
    changelog = "https://github.com/Vysp3r/ProtonPlus/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ getchoo ];
    platforms = lib.platforms.linux;
  };
})
