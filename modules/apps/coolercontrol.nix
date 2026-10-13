{ self, inputs, ... }:
{
  flake.modules = {
    homeManager.coolercontrol =
      { pkgs, ... }:
      {
        imports = [ inputs.coolercontrol-nix.homeModules.default ];
        programs.coolercontrol = {
          enable = true;
          settings = {
            apply_on_boot = true;
            compress = true;
            drivetemp_suspend = false;
            hide_duplicate_devices = true;
            liquidctl_integration = true;
            no_init = false;
            startup_delay = 2;
            thinkpad_full_speed = false;
          };
        };
        xdg.autostart.entries = [
          "${pkgs.coolercontrol.coolercontrol-gui}/share/applications/org.coolercontrol.CoolerControl.desktop"
        ];
      };
    nixos.coolercontrol =
      { pkgs, ... }:
      {
        imports = [ inputs.coolercontrol-nix.nixosModules.default ];
        boot.kernelModules = [ "nct6775" ]; # Otherwise CoolerControl warns
        environment.systemPackages = with pkgs; [
          liquidctl
          lm_sensors
        ];
        home-manager.sharedModules = [ self.modules.homeManager.coolercontrol ];
        nixpkgs.overlays = [ inputs.coolercontrol-nix.overlays.default ];
        preservation.preserveAt."/persist".directories = [
          "/etc/coolercontrol"
          "/var/lib/coolercontrol"
        ];
        programs.coolercontrol.enable = true;
        systemd.services.coolercontrold.path = [ pkgs.kmod ];
      };
  };
  flake-file.inputs.coolercontrol-nix = {
    inputs = {
      flake-parts.follows = "flake-parts";
      git-hooks.follows = "git-hooks-nix";
      home-manager.follows = "home-manager";
      nixpkgs.follows = "nixpkgs";
    };
    url = "github:Daaboulex/coolercontrol-nix";
  };
}
