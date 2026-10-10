{ self, ... }:
{
  flake.modules.nixos.profile-kde =
    { config, pkgs, ... }:
    let
      inherit (config.my) user;
      inherit (config.users.users.${user}) home;
      accountsServiceUser = pkgs.writeText "accountsservice-${user}" ''
        [User]
        Email=keenanweaver@protonmail.com
        Icon=/var/lib/AccountsService/icons/${user}
        SystemAccount=false
      '';
      avatar = ../../../assets/theming/avatar.jpg;
    in
    {
      imports = with self.modules.nixos; [
        catppuccin
        kde
        plasma-manager
      ];
      security.pam.services.login.enableKwallet = true;
      systemd.tmpfiles.rules = [
        "L+ /var/lib/AccountsService/icons/${user} - - - - ${avatar}"
        "L+ /var/lib/AccountsService/users/${user} - - - - ${accountsServiceUser}"
        "L+ ${home}/.face.icon - - - - ${avatar}"
      ];
    };
}
