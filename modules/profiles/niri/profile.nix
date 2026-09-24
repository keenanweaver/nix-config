{ self, ... }:
{
  flake.modules = {
    homeManager.profile-niri.imports = with self.modules.homeManager; [
      niri
      noctalia
    ];
    nixos.profile-niri.imports = with self.modules.nixos; [
      niri
      noctalia
    ];
  };
}
