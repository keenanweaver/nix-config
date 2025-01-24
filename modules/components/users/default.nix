{
  lib,
  config,
  username,
  fullname,
  pkgs,
  ...
}:
let
  cfg = config.users;
in
{
  options = {
    users = {
      enable = lib.mkEnableOption "Enable users in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    users = {
      defaultUserShell = pkgs.zsh;
      mutableUsers = true;
      users = {
        "${username}" = {
          description = "${fullname}";
          isNormalUser = true;
          initialHashedPassword = "$y$j9T$B1obD.4xOr/6gJ6FCsu1v/$7axAjbaqRpFR3zGZVbOuCRGUNGJXyRxdavAHIyOdyK.";
          extraGroups = [
            "adbusers"
            "audio"
            "input"
            "networkmanager"
            "plugdev"
            "realtime"
            "uinput"
            "video"
            "wheel"
          ];
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN76CGOScFN8M/6oDyry/iP95DF0bTHixmk73fKsRP+f keenanweaver@protonmail.com"
          ];
        };
      };
    };
    home-manager.users.${username} = { };
  };
}
