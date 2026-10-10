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
      systemd = {
        services.accounts-daemon.preStart = ''
          install -Dm600 -o root -g root ${accountsServiceUser} /var/lib/AccountsService/users/${user}
        '';
        tmpfiles.rules = [
          "L+ /var/lib/AccountsService/icons/${user} - - - - ${avatar}"
          "L+ ${home}/.face.icon - - - - ${avatar}"
        ];
      };
    };
}
