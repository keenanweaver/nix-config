{ self, ... }:
{
  flake.modules = {
    homeManager.profile-workstation =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ mumble ];
      };
    nixos.profile-workstation = {
      imports = [ self.modules.nixos.profile-desktop ];
      home-manager.sharedModules = [ self.modules.homeManager.profile-workstation ];
      programs.solaar.enable = true;
    };
  };
}
