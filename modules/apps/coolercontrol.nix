{ self, ... }:
{
  flake.modules = {
    homeManager.coolercontrol =
      { pkgs, ... }:
      {
        xdg.autostart.entries = [
          "${pkgs.coolercontrol.coolercontrol-gui}/share/applications/org.coolercontrol.CoolerControl.desktop"
        ];
      };
    nixos.coolercontrol =
      { pkgs, ... }:
      {
        boot.kernelModules = [ "nct6775" ]; # Otherwise CoolerControl warns
        environment.systemPackages = with pkgs; [
          liquidctl
          lm_sensors
        ];
        home-manager.sharedModules = [ self.modules.homeManager.coolercontrol ];
        preservation.preserveAt."/persist".directories = [
          "/etc/coolercontrol"
          "/var/lib/coolercontrol"
        ];
        programs.coolercontrol.enable = true;
      };
  };
}
