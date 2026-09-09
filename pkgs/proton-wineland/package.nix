{
  lib,
  fetchurl,
  stdenvNoCC,
  writeScript,
  steamDisplayName ? "Proton-Wineland",
  variant ? "x86_64",
}:
let
  hashes = {
    x86_64 = "sha256-kjdgCVj7u08fNUGfKBp8+Yj7MPbizHXwTLmccrWjRZE=";
    x86_64_v3 = "sha256-CoqGTFfXjfk9vkiH0Yg0I2AoZS+O0KfVRfY4dDbhGpA=";
    x86_64_wow64 = "sha256-AqP2X5uX5IwTRKmbPfRkWz53XcXMFrRYZZS8VTvMEXk=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "proton-wineland";
  version = "wineland-11.0-20260908";

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

  passthru.updateScript = writeScript "update-proton-wineland" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq gnused nix
    set -euo pipefail

    repo="https://api.github.com/repos/nanomatters/proton-cachyos/releases"
    tag="$(curl -sL "$repo" | jq -r 'map(select(.tag_name | test("^(cachyos-)?wineland-"))) | .[0].tag_name')"
    if [ -z "$tag" ] || [ "$tag" = "null" ]; then
      echo "failed to resolve latest (cachyos-)wineland-* release tag" >&2
      exit 1
    fi

    file="pkgs/proton-cachyos-wineland/package.nix"

    sed -i "s/version = \".*\";/version = \"$tag\";/" "$file"

    for variant in x86_64 x86_64_wow64 x86_64_v3; do
      url="https://github.com/nanomatters/proton-cachyos/releases/download/$tag/proton-$tag-$variant.tar.xz"
      echo "prefetching $variant: $url" >&2
      hash="$(nix store prefetch-file --json "$url" | jq -r .hash)"
      sed -i "s|^\(\s*$variant = \)\".*\";|\1\"$hash\";|" "$file"
    done
  '';

  meta = {
    description = "Native Wayland Steam overlay and Steam Input support";
    homepage = "https://github.com/nanomatters/proton-cachyos";
    license = lib.licenses.bsd3;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = [ "x86_64-linux" ];
  };
})
