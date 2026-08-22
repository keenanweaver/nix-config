{ self, ... }:
{
  flake.modules = {
    homeManager.profile-pi.imports = with self.modules.homeManager; [
      profile-server
    ];
    nixos.profile-pi =
      { self, lib, ... }:
      {
        imports = with self.modules.nixos; [
          profile-server
        ];
        nix.settings = {
          extra-substituters = [
            "https://nixos-raspberrypi.cachix.org"
          ];
          extra-trusted-public-keys = [
            "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
          ];
        };
        nixpkgs.hostPlatform = lib.mkForce "aarch64-linux";
      };
  };
  flake-file.inputs.nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
}
