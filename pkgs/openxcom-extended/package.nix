{
  fetchFromGitHub,
  nix-update-script,
  openxcom,
}:

openxcom.overrideAttrs (_oldAttrs: {
  pname = "openxcom-extended";
  version = "8.7.0";

  src = fetchFromGitHub {
    owner = "MeridianOXC";
    repo = "OpenXcom";
    rev = "a62371bbd83fba05212bcaaea2ee49af96ac989c";
    hash = "sha256-InPoeQ6aRErCmJYPmMhrV68L3Nl3sfe7klbLfpmhK6A=";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--flake"
      "--version=branch"
    ];
  };
})
