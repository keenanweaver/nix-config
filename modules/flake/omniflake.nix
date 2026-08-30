{
  flake-file.inputs.omniflake = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:fzakaria/omniflake";
  };
}
