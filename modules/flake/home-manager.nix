{ inputs, ... }:
{
  flake.modules = {
    homeManager.profile-base =
      { osConfig, ... }:
      {
        home.stateVersion = osConfig.system.stateVersion;
      };
    nixos.profile-base = {
      imports = [ inputs.home-manager.nixosModules.home-manager ];
      home-manager = {
        backupFileExtension = "hm.bak";
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    };
  };
  flake-file.inputs.home-manager = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:nix-community/home-manager";
  };
}
