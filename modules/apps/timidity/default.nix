{ inputs, home-manager, lib, config, username,  ... }: with lib;
let
  cfg = config.timidity;
in
{
  options = {
    timidity = {
      enable = mkEnableOption "Enable timidity in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      programs.timidity = {
        enable = true;
        extraConfig = ''
          soundfont /home/${username}/Music/soundfonts/default.sf2
        '';
      };
    };
  };
}
