{ inputs, ... }:
{
  flake.modules.nixos.profile-desktop =
    { pkgs, ... }:
    {
      boot = {
        consoleLogLevel = 0;
        initrd = {
          systemd.enable = true;
          verbose = false;
        };
        kernelParams = [
          "loglevel=0"
          "quiet"
          "splash"
          "systemd.show_status=auto"
          "udev.log_level=3"
          "vt.global_cursor_default=0"
        ];
        plymouth = {
          enable = true;
          theme = "mac-style";
          themePackages = [ pkgs.mac-style-plymouth ];
        };
      };
      nixpkgs.overlays = [ inputs.s4rchiso-plymouth-theme.overlays.default ];
    };
  flake-file.inputs.s4rchiso-plymouth-theme = {
    inputs = {
      flake-utils.follows = "flake-utils";
      nixpkgs.follows = "nixpkgs";
    };
    url = "github:SergioRibera/s4rchiso-plymouth-theme";
  };
}
