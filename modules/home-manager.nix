{
  flake.modules = {
    homeManager.base-profile =
      {
        lib,
        osConfig ? null,
        ...
      }:
      lib.mkIf (osConfig != null) {
        home.stateVersion = osConfig.system.stateVersion;
      };
    nixos.base-profile = { inputs, self, ... }: {
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      home-manager = {
        backupFileExtension = "hm.bak";
        extraSpecialArgs = { inherit inputs self; };
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    };
  };
  flake-file.inputs = {
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
  };
}
