{
  lib,
  fetchFromGitHub,
  bash,
  bubblewrap,
  cabextract,
  coreutils,
  curl,
  dbus,
  desktop-file-utils,
  file,
  fontconfig,
  gawk,
  gnutar,
  gzip,
  icoutils,
  imagemagick,
  lsof,
  makeWrapper,
  nix-update-script,
  openssl,
  pciutils,
  stdenvNoCC,
  steam,
  vulkan-tools,
  wmctrl,
  xdg-utils,
  xrandr,
  xrdb,
  xz,
  yad,
  zstd,
}:

let
  portproton-steam-run =
    (steam.override {
      extraLibraries =
        pkgs: with pkgs; [
          atk
          cairo
          fontconfig
          gdk-pixbuf
          glib
          gtk3
          pango
        ];
    }).run;
in
stdenvNoCC.mkDerivation {
  pname = "portproton";
  version = "1.7.5-unstable-2026-01-12";

  src = fetchFromGitHub {
    owner = "Castro-Fidel";
    repo = "PortProton_ALT";
    rev = "06b304c35c10e48b824223c4c9f8345c87689f6d";
    hash = "sha256-JFBhrN9EKpgLOYGdSOlswBUzFKXbzeiXkeuxnDQJPKw=";
  };

  postPatch = ''
    substituteInPlace portproton \
      --replace-fail $'\tif [[ "$script_path" == "/usr/bin" ]] \\\n\t&& [[ -f "' \
                      $'\tif [[ -f "'

    substituteInPlace portproton \
      --replace-fail 'rm -fr "''${PORT_WINE_DATA_PATH}/dist/"' 'echo "Preserving dist/ (NixOS patch)"'
  '';

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 portproton "$out/bin/.portproton-unwrapped"
    install -Dm444 ru.linux_gaming.PortProton.desktop \
      "$out/share/applications/ru.linux_gaming.PortProton.desktop"
    install -Dm444 ru.linux_gaming.PortProton.metainfo.xml \
      "$out/share/metainfo/ru.linux_gaming.PortProton.metainfo.xml"
    install -Dm444 ru.linux_gaming.PortProton.svg \
      "$out/share/icons/hicolor/scalable/apps/ru.linux_gaming.PortProton.svg"

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram "$out/bin/.portproton-unwrapped" \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          bubblewrap
          cabextract
          coreutils
          curl
          desktop-file-utils
          dbus
          fontconfig
          file
          gawk
          gnutar
          gzip
          icoutils
          imagemagick
          lsof
          openssl
          pciutils
          vulkan-tools
          wmctrl
          xdg-utils
          xrandr
          xrdb
          xz
          yad
          zstd
        ]
      }

    makeWrapper ${lib.getExe portproton-steam-run} "$out/bin/portproton" \
      --add-flags "$out/bin/.portproton-unwrapped"
  '';

  dontBuild = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--flake"
      "--version=branch"
    ];
  };

  meta = {
    description = "Tool to easily run Windows games and software on Linux via Proton/Wine";

    longDescription = ''
      PortProton bundles Valve's Proton and Proton-GE
      with a Steam Runtime container, MangoHud and vkBasalt behind a
      yad-based GUI, plus one-click installers for common Windows game
      launchers.
    '';

    homepage = "https://github.com/Castro-Fidel/PortWINE";
    changelog = "https://github.com/Castro-Fidel/PortWINE/blob/master/data_from_portwine/changelog_en";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.linux;
    mainProgram = "portproton";
  };
}
