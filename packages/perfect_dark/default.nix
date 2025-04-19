{
  romID ? "ntsc-final",

  lib,

  fetchFromGitHub,
  stdenv,

  SDL2,
  zlib,

  pkg-config,
  cmake,
  python3,
  libGL,
}:
let
  roms = [
    "ntsc-final"
    "pal-final"
    "jpn-final"
  ];
in
assert lib.assertOneOf "romID" romID roms;
stdenv.mkDerivation rec {
  pname = "perfect_dark";
  version = "0-unstable-2025-03-30";

  src = fetchFromGitHub {
    owner = "fgsfdsfgs";
    repo = "perfect_dark";
    rev = "0ac5fdd5c3ffc13b453e52dceef6beb219606cc3";
    hash = "sha256-+d4N6A00nVViQlzjOq5Ey6aUOQHEhWJhOY8FmIuTkHo=";
  };

  buildInputs = [
    SDL2
    libGL
    zlib
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    python3
  ];

  # the project uses git to retrieve version informations but our fetcher deletes the .git
  # so we replace the commands with the correct data directly
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'git rev-parse --short HEAD' 'echo ${builtins.substring 0 9 src.rev}' \
      --replace-fail 'git rev-parse --abbrev-ref HEAD' 'echo port'
  '';

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ]; # otherwise fails to build
  hardeningEnable = [ "pie" ];

  preConfigure = ''
    patchShebangs .
  '';

  cmakeFlags = [
    "-DROMID=${romID}"
  ];

  installPhase = ''
    runHook preInstall
    pushd ..

    install -Dm 755 build/pd.x86_64 $out/bin/pd

    install -Dm 644 dist/linux/*.desktop -t $out/share/applications/
    install -Dm 644 dist/linux/*.png -t $out/share/pixmaps/


    popd
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/fgsfdsfgs/perfect_dark/";
    description = "Modern cross-platform port of Perfect Dark";
    longDescription = ''
      This is a port of Ryan Dywer's decompilation of classic N64 shooter Perfect Dark to modern systems.

      You'll need to provide a copy of the ROM at $HOME/.local/share/perfectdark/data/pd.${romID}.z64 to launch to game.

      You can also change the ROM variant of this game with an expression like this:

      `pd.override { romID = "jpn-final" }`

      Supported romIDs are `${lib.generators.toPretty { } roms}`.

      `ntsc-final` the default as it is the only recommended one by upstream.
    '';
    mainProgram = "pd";
    platforms = [
      #"i686-linux"
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [ PaulGrandperrin ];
    license = with lib.licenses; [
      # perfect_dark, khrplatform.h, port/fast3d
      mit
      # tools/mkrom/gzip
      gpl3Plus
      # the project's original work is licensed under MIT
      # but a lot of it can be seen as a derivative work of an unfree piece of software
      # we account for that here
      unfree
    ];
  };
}
