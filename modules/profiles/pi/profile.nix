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
        boot.loader = {
          efi.canTouchEfiVariables = lib.mkForce false;
          limine = {
            enable = lib.mkForce false;
            additionalFiles = lib.mkForce { };
            extraEntries = lib.mkForce "";
          };
        };
        hardware.deviceTree.enable = lib.mkForce false;
        nix.settings = {
          extra-substituters = [
            "https://nixos-raspberrypi.cachix.org"
          ];
          extra-trusted-public-keys = [
            "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
          ];
        };
        nix-mineral.filesystems.normal."/boot".enable = lib.mkForce false;
        nixpkgs.hostPlatform = lib.mkForce "aarch64-linux";
        system.boot.loader.kernelFile = lib.mkForce "Image";
      };
  };
  flake-file.inputs.nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
}
