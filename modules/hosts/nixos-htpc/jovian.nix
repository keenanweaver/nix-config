{ inputs, ... }:
{
  configurations.nixos.nixos-htpc.module =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.nyx.vendored.jovian.nixosModules.default
      ];
      home-manager.users.${config.my.user}.home.file = {
        # https://github.com/Jovian-Experiments/Jovian-NixOS/issues/460#issuecomment-3439375088
        ".local/share/Steam/.cef-enable-remote-debugging".text = "";
        "Desktop/Reboot-to-UEFI.desktop".source =
          (pkgs.makeDesktopItem {
            desktopName = "Reboot to UEFI";
            exec = "systemctl reboot --firmware-setup";
            icon = "system-reboot-symbolic";
            name = "Reboot-to-UEFI";
            startupNotify = false;
            terminal = false;
            type = "Application";
          })
          + "/share/applications/Reboot-to-UEFI.desktop";
        "Desktop/Return-to-Gaming-Mode.desktop".source =
          (pkgs.makeDesktopItem {
            desktopName = "Return to Gaming Mode";
            exec = "steamosctl switch-to-game-mode";
            icon = "steam";
            name = "Return-to-Gaming-Mode";
            startupNotify = false;
            terminal = false;
            type = "Application";
          })
          + "/share/applications/Return-to-Gaming-Mode.desktop";
      };
      jovian = {
        decky-loader = {
          enable = true;
          stateDir = "/home/decky-loader"; # Fix Audio Loader
          user = config.my.user;
        };
        hardware.has.amd.gpu = true;
        steam = {
          enable = true;
          autoStart = true;
          desktopSession = "plasma";
          updater.splash = "jovian";
          user = config.my.user;
        };
        steamos = {
          enableZram = false; # Conflicts with zswap
        };
      };
      my.permittedInsecurePackages = [
        "pnpm-9.15.9" # Decky Loader
      ];
      preservation.preserveAt."/persist".directories = [ config.jovian.decky-loader.stateDir ];
      services = {
        displayManager.plasma-login-manager.enable = false; # Conflicts with Jovian
        pulseaudio.enable = lib.mkForce false;
        scx.enable = lib.mkForce false; # Conflicts with scx-loader
      };
    };
}
