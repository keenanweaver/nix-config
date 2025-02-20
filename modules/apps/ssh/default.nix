{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.ssh;
in
{
  options = {
    ssh = {
      enable = lib.mkEnableOption "Enable ssh in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.ssh = {
      startAgent = true;
    };
    services.openssh = {
      enable = true;
      listenAddresses = [
        {
          addr = "0.0.0.0";
          port = 6777;
        }
      ];
      ports = [ 6777 ];
      settings = {
        AllowUsers = [ "${username}" ];
        # Allow forwarding ports to everywhere
        GatewayPorts = "clientspecified";
        KbdInteractiveAuthentication = false;
        KexAlgorithms = [
          "sntrup761x25519-sha512@openssh.com"
          "curve25519-sha256"
          "curve25519-sha256@libssh.org"
          #"diffie-hellman-group-exchange-sha256"
        ];
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        # Automatically remove stale sockets
        StreamLocalBindUnlink = "yes";
        UseDns = true;
        X11Forwarding = true;
      };
    };
    home-manager.users.${username} =
      { config, pkgs, ... }:
      {
        home.packages = with pkgs; [ sshs ];
        programs.ssh = {
          enable = true;
          extraConfig = ''
            Host nixos-desktop
              HostName nixos-desktop
              User ${username}
              Port 6777
            Host nixos-laptop
              HostName nixos-laptop
              User ${username}
              Port 6777
            Host unraid
              HostName crusader
              User root
              Port 6777
            Host nixos-unraid
              HostName nixos-unraid
              User ${username}
              Port 6777
            Host remorsepi
              HostName remorsepi
              User ${username}
              Port 6777
            Host regretpi
              HostName regretpi
              User ${username}
              Port 6777
            Host mister
              HostName mister
              User root
            Host Mumble
              HostName game-central.party
              User ${username}
              Port 6777
            Host unifi-CKG2
              HostName unifi
              User keenanweaver
            Host opnsense
              HostName opnsense
              User ${username}
            Host bazzite
              HostName bazzite
              User bazzite
          '';
        };
        xdg.autostart.entries =
          let
            desktopEntry = (
              pkgs.makeDesktopItem {
                name = "ssh-add";
                desktopName = "ssh-add";
                exec = "ssh-add -q ${config.home.homeDirectory}/.ssh/id_ed25519";
                comment = "Run ssh-add";
                terminal = false;
                startupNotify = false;
              }
            );
          in
          [
            "${desktopEntry}/share/applications/${desktopEntry.name}"
          ];
      };
  };
}
