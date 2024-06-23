{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.fd;
in
{
  options = {
    fd = {
      enable = lib.mkEnableOption "Enable fd in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.fd = {
        enable = true;
        extraOptions = [
          "--no-ignore"
          "--absolute-path"
        ];
        hidden = true;
        ignores = [ ".git/" ];
      };
    };
  };
}
