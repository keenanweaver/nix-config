{ self, config, ... }:
let
  inherit (config) caches;
in
{
  configurations.nixos.nixos-desktop.module =
    { config, pkgs, ... }:
    {
      imports = with self.modules.nixos; [
        self.diskoConfigurations.nixos-desktop

        profile-workstation
        profile-kde
        profile-gaming

        amd
        cachyos-kernel
        coolercontrol
        secure-boot
        zerotier

        flatpak-games
        moonshine
        obs
        obs-flatpak
        retroarch
        stream-controller
        yeetmouse

        doom
      ];
      boot = {
        binfmt.emulatedSystems = [
          "aarch64-linux"
        ];
        extraModulePackages = [ config.boot.kernelPackages.nct6687d ];
        kernelModules = [ "nct6687" ];
        kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-zen4;
      };
      home-manager.users.${config.my.user} =
        {
          lib,
          config,
          pkgs,
          ...
        }:
        {
          xdg.desktopEntries = import ./_desktop-entries.nix {
            inherit
              config
              lib
              pkgs
              ;
          };
        };
      host = {
        cpu = "7950X3D";
        cpuHasVcache = true;
        fpsLimit = "324,0,240,120,60,30";
        gpu = "7900XTX";
        lanInterface = "enp10s0";
        pciDev = "0000:03:00.0";
        primaryMonitor = "DP-1";
        wineCpuTopology = "15:1,2,3,4,5,6,7,16,17,18,19,20,21,22,23";
        ztAdapter = "zt6ntckupu";
        ztConcurrency = 16;
      };
      nix.settings = self.lib.mkCacheSettings (
        with caches;
        [
          noctalia
          raspberrypi
        ]
      );
      # Skip core 0, testing https://kish1n.io/posts/is-core-0-sabotaging-your-performance/
      programs.gamemode.settings.cpu.pin_cores = "1-7,16-23";
      system.stateVersion = "26.05";
      systemd.tmpfiles.rules = [
        "d /mnt/Games2 0755 ${config.my.user} users - -"
      ];
    };
}
