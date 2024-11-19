{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.zed;
in
{
  options = {
    zed = {
      enable = lib.mkEnableOption "Enable zed in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.zed-editor = {
        enable = true;
        extensions = [
          "ansible"
          "nix"
        ];
        # https://github.com/nix-community/home-manager/pull/6094
        /*
          extraPackages = [

               ];
        */
      };
    };
  };
}
