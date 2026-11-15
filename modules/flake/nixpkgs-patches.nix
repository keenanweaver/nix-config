{
  flake-file.inputs = {
    # https://github.com/NixOS/nixpkgs/pull/584805
    nixpkgs-patch-heroic-modernize = {
      flake = false;
      url = "https://github.com/NixOS/nixpkgs/pull/584805.diff";
    };
  };
}
