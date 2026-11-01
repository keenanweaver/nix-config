{ self, ... }:
{
  configurations.nixos.nixos-htpc.module =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      imports = with self.modules.nixos; [
        self.diskoConfigurations.nixos-htpc

        profile-desktop
        profile-kde
        profile-gaming

        amd
        cachyos-kernel
        coolercontrol
        secure-boot

        obs
      ];
      boot = {
        kernel.sysctl."net.ipv4.tcp_mtu_probing" = lib.mkForce null;
        kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v3;
        loader.timeout = 0;
        plymouth = {
          theme = "steamos";
          themePackages = [ pkgs.local.plymouth-theme-steamos ];
        };
      };
      home-manager.users.${config.my.user} =
        { config, ... }:
        {
          services.ludusavi.settings.backup.path = "${config.home.homeDirectory}/Games/ludusavi";
        };
      host = {
        cpu = "5800X";
        fpsLimit = "120,0,60,30";
        gpu = "9070XT";
        pciDev = "0000:08:00.0";
        primaryMonitor = "HDMI-1";
      };
      services.nixos-plymouth.enable = false;
      system.stateVersion = "26.05";
    };
}
