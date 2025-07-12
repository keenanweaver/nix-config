{
  lib,
  config,
  pkgs,
  username,
  ...
}:
let
  cfg = config.streamcontroller;
in
{
  options = {
    streamcontroller = {
      enable = lib.mkEnableOption "Enable streamcontroller in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.streamcontroller = {
      enable = true;
    };
    services.udev.packages = with pkgs; [
      (writeTextFile {
        name = "40-streamdeck.rules";
        text = builtins.readFile (fetchurl {
          url = "https://raw.githubusercontent.com/streamduck-org/elgato-streamdeck/main/40-streamdeck.rules";
          hash = "sha256-kqZf92JWFJosAG1hfX4TR2aH6eqLc8a1L9XiDodHYso=";
        });
        destination = "/etc/udev/rules.d/40-streamdeck.rules";
      })
    ];
    home-manager.users.${username} = { };
  };
}
