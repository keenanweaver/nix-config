{
  fetchFromGitHub,
  nix-update-script,
  openxcom,
}:

openxcom.overrideAttrs (_oldAttrs: {
  pname = "openxcom-extended";
  version = "8.6.4";

  src = fetchFromGitHub {
    owner = "MeridianOXC";
    repo = "OpenXcom";
    rev = "a077141b4102d669cce42155478d2f6404953605";
    hash = "sha256-KflGWJgUW4kVzCxDJxSq96dz638mfphiiOSyBkC1sY4=";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--flake"
      "--version=branch"
    ];
  };
})
