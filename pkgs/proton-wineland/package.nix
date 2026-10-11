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
    x86_64 = "sha256-PBvOQ47CYtvEJ6FyU7JWyiL2yKyS6fvSRMYAS4zr0JE=";
    x86_64_v3 = "sha256-Mvpq6LwNj7m/uHgslIcUjUjgzytYec5Gt1OyugUp0Oc=";
    x86_64_wow64 = "sha256-BW3WH14HYYlEt1LopaAZ0W8ORLqWfAwXrJXeEKjCHuk=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "proton-wineland";
  version = "wineland-11.0-20261011";

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
    cp -r -t $steamcompattool ./*
    chmod -R u+rwX,go+rX $steamcompattool

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

    file="pkgs/proton-wineland/package.nix"

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
