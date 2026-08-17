{ self, ... }:
{
  flake.modules = {
    homeManager.base-profile =
      { config, ... }:
      {
        home = {
          language = {
            base = "en_US.UTF-8";
            collate = "C.UTF-8";
          };
          sessionPath = [
            "${config.home.homeDirectory}/.bin"
            "${config.home.homeDirectory}/.local/bin"
          ];
        };
        xdg = {
          enable = true;
          autostart.enable = true;
          userDirs = {
            enable = true;
            createDirectories = true;
            projects = null;
            publicShare = null;
            setSessionVariables = true;
            templates = null;
          };
        };
      };
    nixos.base-profile =
      {
        inputs,
        config,
        pkgs,
        ...
      }:
      {
        imports = with self.modules.nixos; [
          local-packages
        ];
        console = {
          earlySetup = true;
          font = "ter-v28b";
          packages = with pkgs; [
            terminus_font
          ];
        };
        environment = {
          etc.motd.text = ''
            NixOS release: ${config.system.nixos.release}
            Nixpkgs revision: ${inputs.nixpkgs.rev}
          '';
          homeBinInPath = true;
          localBinInPath = true;
          shells = with pkgs; [
            bash
            zsh
          ];
          stub-ld.enable = true;
        };
        i18n.defaultLocale = "en_US.UTF-8";
        nixpkgs.config.permittedInsecurePackages = [
          "electron-40.10.5" # ?
          "olm-3.2.16" # Neochat
          "pnpm-9.15.9" # Decky Loader
        ];
        programs.iotop.enable = true;
        services = {
          earlyoom = {
            enable = true;
            freeMemThreshold = 5;
          };
          journald.extraConfig = ''
            SystemMaxUse=50M
          '';
          logrotate.enable = true;
        };
        systemd.settings.Manager = {
          DefaultTimeoutStartSec = "15s";
          DefaultTimeoutStopSec = "10s";
        };
        time.timeZone = "America/Chicago";
        users.motdFile = "/etc/motd";
      };
  };
  flake-file.description = "Keenan's NixOS configuration";
}
