{
  flake.modules.nixos.profile-desktop =
    { inputs, pkgs, ... }:
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
      catppuccin.plymouth.enable = false;
      nixpkgs.overlays = [ inputs.omniflake.flakes.s4rchiso-plymouth-theme.overlays.default ];
    };
}
