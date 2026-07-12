{
  configurations.nixos.nixos-htpc.module =
    {
      config,
      lib,
      pkgs,
      inputs,
      ...
    }:
    {
      imports = [
        inputs.jovian.nixosModules.default
      ];
      home-manager.users.${config.my.user} = {
        home.file."Desktop/Return-to-Gaming-Mode.desktop".source =
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
        };
        hardware = {
          has.amd.gpu = true;
        };
        steam = {
          enable = true;
          autoStart = true;
          desktopSession = "plasma";
          updater.splash = "jovian";
          user = config.my.user;
        };
        steamos = {
          enableZram = lib.mkForce false; # Conflicts with zswap
        };
      };
      preservation.preserveAt."/persist".directories = [ "/var/lib/decky-loader" ];
      services = {
        displayManager.plasma-login-manager.enable = lib.mkForce false; # Conflicts with Jovian
        scx.enable = lib.mkForce false; # Conflicts with scx-loader
      };
      # Create Steam CEF debugging file if it doesn't exist for Decky Loader.
      # https://github.com/Jovian-Experiments/Jovian-NixOS/issues/460#issuecomment-3439375088
      systemd.services.steam-cef-debug = lib.mkIf config.jovian.decky-loader.enable {
        description = "Create Steam CEF debugging file";
        serviceConfig = {
          ExecStart = "${lib.getExe pkgs.bash} -c 'mkdir -p ~/.steam/steam && [ ! -f ~/.steam/steam/.cef-enable-remote-debugging ] && touch ~/.steam/steam/.cef-enable-remote-debugging || true'";
          Type = "oneshot";
          User = config.jovian.steam.user;
        };
        wantedBy = [ "multi-user.target" ];
      };
    };
  flake-file.inputs = {
    jovian = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Jovian-Experiments/Jovian-NixOS";
    };
  };
}
