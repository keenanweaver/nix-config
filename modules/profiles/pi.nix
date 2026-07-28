{ self, ... }:
{
  flake-file.inputs = {
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
  };

  flake.modules = {
    homeManager.pi-profile = {
      imports = with self.modules.nixos; [
        server-profile
      ];
    };

    nixos.pi-profile =
      { self, lib, ... }:
      {
        imports = with self.modules.nixos; [
          server-profile
        ];

        nixConfig = {
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

}
