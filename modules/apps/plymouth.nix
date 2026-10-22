{ inputs, ... }:
{
  flake.modules.nixos.profile-desktop =
    { lib, ... }:
    {
      imports = [ inputs.nixos-plymouth.nixosModules.default ];
      boot = {
        consoleLogLevel = 0;
        initrd.verbose = false;
        kernelParams = [
          "loglevel=0"
          "quiet"
          "splash"
          "systemd.show_status=auto"
          "udev.log_level=3"
          "vt.global_cursor_default=0"
        ];
        plymouth.enable = true;
      };
      services.nixos-plymouth.enable = lib.mkDefault true;
    };
  flake-file.inputs.nixos-plymouth = {
    inputs = {
      nixos-branding.inputs = {
        flake-compat.follows = "flake-compat";
        pre-commit-hooks.follows = "git-hooks-nix";
        treefmt-nix.follows = "treefmt-nix";
      };
      nixpkgs.follows = "nixpkgs";
    };
    url = "github:iltgg/nixos_plymouth";
  };
}
