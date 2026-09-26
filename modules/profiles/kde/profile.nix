{ self, ... }:
{
  flake.modules.nixos.profile-kde = {
    imports = with self.modules.nixos; [
      catppuccin
      kde
      plasma-manager
    ];
    security.pam.services.login.enableKwallet = true;
  };
}
