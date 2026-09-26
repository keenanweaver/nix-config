{ self, ... }:
{
  configurations.nixos.remorse = {
    module = {
      imports = with self.modules.nixos; [
        profile-server

        pi4
      ];
      networking.hostName = "remorse";
      system.stateVersion = "26.05";
    };
    system = "aarch64-linux";
  };
}
