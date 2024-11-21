{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.keyd;
in
{
  options = {
    keyd = {
      enable = lib.mkEnableOption "Enable keyd in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    services.keyd = {
      enable = true;
      keyboards.default.settings = {
        main = {
          capslock = "overload(control, esc)";
        };
      };
    };

    users.users.${username}.extraGroups = [ "keyd" ];

    home-manager.users.${username} = { };
  };
}
