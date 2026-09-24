{
  flake.modules = {
    homeManager.profile-base.programs.nix-index = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
    };
    nixos.profile-base = { inputs, ... }: {
      imports = [
        inputs.nix-index-database.nixosModules.default
      ];
    };
  };
  flake-file.inputs.nix-index-database = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:nix-community/nix-index-database";
  };
}
