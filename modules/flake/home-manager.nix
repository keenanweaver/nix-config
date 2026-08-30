{
  flake.modules = {
    homeManager.profile-base =
      {
        lib,
        osConfig ? null,
        ...
      }:
      lib.mkIf (osConfig != null) {
        home.stateVersion = osConfig.system.stateVersion;
      };
    nixos.profile-base =
      { self, inputs, ... }:
      {
        imports = [ inputs.omniflake.flakes.home-manager.nixosModules.home-manager ];
        home-manager = {
          backupFileExtension = "hm.bak";
          extraSpecialArgs = { inherit inputs self; };
          useGlobalPkgs = true;
          useUserPackages = true;
        };
      };
  };
}
