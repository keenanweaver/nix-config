{
  lib,
  fetchurl,
  stdenvNoCC,
  writeScript,
  steamDisplayName ? "Proton-CachyOS-Wineland",
  variant ? "x86_64",
}:
let
  hashes = {
    x86_64 = "sha256-xEk4Df/0fBXMpTd3mFTn0ryMRpzSa8u5fOGu4Ts5hAc=";
    x86_64-wow64 = "sha256-naQhrAr1BjCeDFTFrPvD+bY4h5LgcaTw26KyseqWIjM=";
    x86_64_v3 = "sha256-e27t/8c34YvXda0wMSYErYsBcw9jFBgVtLQ7AyqY1p8=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "proton-cachyos-wineland";
  version = "cachyos-wineland-11.0-20260713.4-slr";

  src = fetchurl {
    url = "https://github.com/nanomatters/proton-cachyos/releases/download/${finalAttrs.version}/proton-${finalAttrs.version}-${variant}.tar.xz";
    hash = hashes.${variant};
  };

  outputs = [
    "out"
    "steamcompattool"
  ];

  installPhase = ''
    runHook preInstall

    # Make it impossible to add to an environment. You should use the
    # appropriate NixOS option. Also leave some breadcrumbs in the file.
    echo "${finalAttrs.pname} should not be installed into environments. Please use programs.steam.extraCompatPackages instead." > $out

    mkdir $steamcompattool
    cp -r --no-preserve=mode -t $steamcompattool ./*

    runHook postInstall
  '';

  preFixup = ''
    substituteInPlace "$steamcompattool/compatibilitytool.vdf" \
      --replace-fail "proton-${finalAttrs.version}-${variant}" "${steamDisplayName}"
  '';

  dontBuild = true;
  dontConfigure = true;

  passthru.updateScript = writeScript "update-proton-cachyos-wineland" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    repo="https://api.github.com/repos/nanomatters/proton-cachyos/releases"
    tag="$(curl -sL "$repo" | jq -r 'map(select(.tag_name | startswith("cachyos-wineland-"))) | .[0].tag_name')"
    version="''${tag#cachyos-wineland-}"
    update-source-version proton-cachyos-wineland "$version"
  '';

  meta = {
    description = ''
      CachyOS's Proton build, patched by the "wineland" fork for native
      Wayland Steam overlay and Steam Input support.

      (This is intended for use in the `programs.steam.extraCompatPackages`
      option only.)
    '';

    homepage = "https://github.com/nanomatters/proton-cachyos";
    license = lib.licenses.bsd3;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = [ "x86_64-linux" ];
  };
})
