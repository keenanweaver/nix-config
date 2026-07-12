{
  flake.modules = {
    homeManager.gaming-profile = { pkgs, ... }: {
      xdg.autostart.entries = [
        "${pkgs.coolercontrol.coolercontrol-gui}/share/applications/org.coolercontrol.CoolerControl.desktop"
      ];
    };
    nixos.gaming-profile = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        liquidctl
        lm_sensors
      ];
      preservation.preserveAt."/persist".directories = [
        "/etc/coolercontrol"
        "/var/lib/coolercontrol"
      ];
      programs.coolercontrol = {
        enable = true;
      };
    };
  };
}
