{ self, ... }:
{
  flake.modules = {
    homeManager.pi-profile = {
      imports = with self.modules.nixos; [
        server-profile
      ];
    };
    nixos.pi-profile = { inputs, self, ... }: {
      imports =
        with inputs.nixos-raspberrypi.nixosModules;
        with self.modules.nixos;
        [
          raspberry-pi-4.base

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
    };
  };
  flake-file.inputs = {
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
  };

}
