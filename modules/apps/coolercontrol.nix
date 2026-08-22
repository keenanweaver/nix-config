{
  flake.modules = {
    homeManager.profile-gaming =
      { pkgs, ... }:
      {
        xdg.autostart.entries = [
          "${pkgs.coolercontrol.coolercontrol-gui}/share/applications/org.coolercontrol.CoolerControl.desktop"
        ];
      };
    nixos.profile-gaming =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          liquidctl
          lm_sensors
        ];
        preservation.preserveAt."/persist".directories = [
          "/etc/coolercontrol"
          "/var/lib/coolercontrol"
        ];
        programs.coolercontrol.enable = true;
      };
  };
}
