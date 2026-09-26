{ self, ... }:
{
  flake.modules.nixos.profile-workstation = {
    imports = [ self.modules.nixos.profile-desktop ];
    home-manager.sharedModules = [ self.modules.homeManager.profile-workstation ];
  };
}
