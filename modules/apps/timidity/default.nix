{ lib, config, username, ... }:
let
  cfg = config.timidity;
in
{
  options = {
    timidity = {
      enable = lib.mkEnableOption "Enable timidity in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = { username, ... }: {
      programs.timidity = {
        enable = true;
        extraConfig = ''
          soundfont /home/${username}/Music/soundfonts/default.sf2
        '';
      };
    };
  };
}
