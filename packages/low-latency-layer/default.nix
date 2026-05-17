{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  vulkan-headers,
  vulkan-utility-libraries,
  vulkan-loader,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "low-latency-layer";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Korthos-Software";
    repo = "low_latency_layer";
    tag = "v" + finalAttrs.version;
    hash = "sha256-dDZVQqVL47cWSZOwcavqR1Cmh8rsCdlbm+vPhUZklhw=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    vulkan-headers
    vulkan-utility-libraries
    vulkan-loader
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hardware-agnostic Vulkan implicit layer for input latency reduction (Reflex / Anti-Lag)";
    homepage = "https://github.com/Korthos-Software/low_latency_layer";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ keenanweaver ];
  };
})
