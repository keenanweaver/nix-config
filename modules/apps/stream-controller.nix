{
  flake.modules.nixos.stream-controller = { pkgs, ... }: {
    programs.streamcontroller = {
      enable = true;
    };
    services.udev.packages = with pkgs; [
      (writeTextFile {
        destination = "/etc/udev/rules.d/40-streamdeck.rules";
        name = "40-streamdeck.rules";
        text = builtins.readFile (fetchurl {
          hash = "sha256-kxIzSbFTTzLXCfjuNvqBh+6SHCrvr31d84UUFxtHUBg=";
          url = "https://raw.githubusercontent.com/streamduck-org/elgato-streamdeck/main/40-streamdeck.rules";
        });
      })
    ];
  };
}
