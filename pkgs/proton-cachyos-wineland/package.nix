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
    x86_64 = "sha256-EvKS33zxX0g7d3Hcn/jcucHHTKsrnmFhtqH6pbCuQ5Q=";
    x86_64-wow64 = "sha256-qQqXm9V63UejYdV24pJBzZ0m8H7GMQCZzFAN2lAfwzk=";
    x86_64_v3 = "sha256-T0v0RPUJM5RBbXHIcF6OojlrUEfo61m1FGuwaHf/+Vc=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "proton-cachyos-wineland";
  version = "cachyos-wineland-11.0-20260713.5-slr";

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
    #!nix-shell -i bash -p curl jq gnused nix
    set -euo pipefail

    repo="https://api.github.com/repos/nanomatters/proton-cachyos/releases"
    tag="$(curl -sL "$repo" | jq -r 'map(select(.tag_name | startswith("cachyos-wineland-"))) | .[0].tag_name')"
    if [ -z "$tag" ] || [ "$tag" = "null" ]; then
      echo "failed to resolve latest cachyos-wineland-* release tag" >&2
      exit 1
    fi

    file="pkgs/proton-cachyos-wineland/package.nix"

    sed -i "s/version = \".*\";/version = \"$tag\";/" "$file"

    for variant in x86_64 x86_64-wow64 x86_64_v3; do
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
