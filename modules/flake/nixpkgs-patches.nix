{
  flake-file.inputs = {
    # https://github.com/NixOS/nixpkgs/pull/584805
    nixpkgs-patch-heroic-modernize = {
      flake = false;
      url = "https://github.com/NixOS/nixpkgs/pull/584805.diff";
    };
    # https://github.com/NixOS/nixpkgs/pull/585753
    nixpkgs-patch-luxtorpeda-bin = {
      flake = false;
      url = "https://github.com/NixOS/nixpkgs/pull/585753.diff";
    };
    # https://github.com/NixOS/nixpkgs/pull/575042
    nixpkgs-patch-openxcom-extended-init = {
      flake = false;
      url = "https://github.com/NixOS/nixpkgs/pull/575042.diff";
    };
  };
}
