{ self, ... }:
{
  configurations.nixos.regret.module =
    {
      inputs,
      lib,
      config,
      pkgs,
      ...
    }:
    {
      imports =
        with self.modules.nixos;
        [
          profile-base
          profile-pi
        ]
        ++ (with inputs.nixos-raspberrypi.nixosModules; [
          inputs.nixos-raspberrypi.lib.inject-overlays
          trusted-nix-caches
          raspberry-pi-4.base
          sd-image
        ]);
      boot.kernelPackages =
        lib.mkForce
          inputs.nixos-raspberrypi.packages.${pkgs.stdenv.hostPlatform.system}.linuxPackages_rpi4;
      home-manager.users.${config.my.user}.imports = with self.modules.homeManager; [
        profile-base
        profile-pi
      ];
      networking.hostName = "regret";
      system.stateVersion = "26.05";
      /*
        virtualisation.quadlet.containers.mister-retroarch-save-sync = {
             autoStart = true;
             containerConfig = {
               autoUpdate = "registry";
               environments = {
                 RETROARCH_CORES = "FCEUmm, Snes9x, Gambatte, mGBA, Genesis Plus GX, Beetle PSX HW, Mupen64Plus-Next";
                 TZ = config.time.timeZone;
               };
               image = "ghcr.io/juaniwck/mister-retroarch-save-sync:latest";
               volumes = [
                 "/mnt/retroarch:/retroarch"
                 "/mnt/mister/saves:/mister/saves"
               ];
             };
             serviceConfig.Restart = "unless-stopped";
           };
      */
    };
}
