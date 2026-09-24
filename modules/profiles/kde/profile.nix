{ self, ... }:
{
  flake.modules = {
    homeManager.profile-kde.imports = with self.modules.homeManager; [
      catppuccin
      kde
      plasma-manager
    ];
    nixos.profile-kde = {
      imports = with self.modules.nixos; [
        catppuccin
        kde
      ];
      security.pam.services.login.enableKwallet = true;
    };
  };
}
