{ self, ... }:
{
  configurations.nixos.remorse = {
    module = {
      imports = with self.modules.nixos; [
        mullvad-tunnel
        profile-server

        pi4
      ];
      system.stateVersion = "26.05";
    };
    system = "aarch64-linux";
  };
}
