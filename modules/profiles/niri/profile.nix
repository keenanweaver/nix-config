{ self, ... }:
{
  flake.modules.nixos.profile-niri.imports = with self.modules.nixos; [
    niri
    noctalia
  ];
}
