{
  lib,
  config,
  username,
  ...
}:
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
    home-manager.users.${username} =
      {
        programs.timidity = {
          enable = true;
          extraConfig = ''
            soundfont ${config.home.homeDirectory}/Music/soundfonts/default.sf2
          '';
        };
      };
  };
}
