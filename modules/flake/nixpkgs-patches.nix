{
  flake-file.inputs = {
    # https://github.com/NixOS/nixpkgs/pull/584263 (merged)
    nixpkgs-patch-amethyst-mod-manager-bump = {
      flake = false;
      url = "https://github.com/NixOS/nixpkgs/compare/faaab5b83d240c3359b9ac92ce6dbd017ba64014...6243396467aff62c9df8d29907b4f92058c094a4.diff";
    };
    # https://github.com/NixOS/nixpkgs/pull/580322 (merged)
    nixpkgs-patch-gpu-screen-recorder-modernize = {
      flake = false;
      url = "https://github.com/NixOS/nixpkgs/compare/9a3c97c772303c3987767e448ddd928294bdaf11...74b89c527c44b19c7396d7686412dab882c7aee7.diff";
    };
    # https://github.com/NixOS/nixpkgs/pull/584805
    nixpkgs-patch-heroic-modernize = {
      flake = false;
      url = "https://github.com/NixOS/nixpkgs/pull/584805.diff";
    };
    # https://github.com/NixOS/nixpkgs/pull/575042
    nixpkgs-patch-openxcom-extended-init = {
      flake = false;
      url = "https://github.com/NixOS/nixpkgs/pull/575042.diff";
    };
    # https://github.com/NixOS/nixpkgs/pull/585019
    nixpkgs-patch-topgrade-system-aws-lc = {
      flake = false;
      url = "https://github.com/NixOS/nixpkgs/pull/585019.diff";
    };
  };
}
