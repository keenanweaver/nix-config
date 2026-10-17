{ self, ... }:
{
  configurations.nixos.regret = {
    module = {
      imports = with self.modules.nixos; [
        profile-server

        pi4
      ];
      system.stateVersion = "26.05";
    };
    system = "aarch64-linux";
  };
}
