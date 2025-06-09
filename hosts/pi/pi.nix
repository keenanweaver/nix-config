{
  lib,
  ...
}:
{
  imports = [
    # System
    #./hardware-configuration.nix
    ./impermanence.nix
    # Profiles
    ../../modules
  ];

  # Custom modules
  server.enable = true;
  # Apps
  btop.enable = lib.mkForce false;
  direnv.enable = lib.mkForce false;
  helix.enable = lib.mkForce false;
  jujutsu.enable = lib.mkForce false;
  nvim.enable = lib.mkForce false;
  virtualization.enable = lib.mkForce false;
  # System
  flatpak.enable = lib.mkForce false;

  nixConfig = {
    extra-substituters = [
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

}
