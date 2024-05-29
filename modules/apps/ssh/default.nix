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
        home.file = {
          desktop-entry-ssh-add = {
            enable = true;
            text = ''
              [Desktop Entry]
              Exec=ssh-add -q .ssh/id_ed25519
              Name=ssh-add
              Type=Application
            '';
            target = "${config.xdg.configHome}/autostart/ssh-add.desktop";
          };
        };
        home.packages = with pkgs; [ sshs ];
        programs.ssh = {
          enable = true;
          extraConfig = ''
            Host nixos-desktop
              HostName 10.20.1.8
              User ${username}
              Port 6777
            Host nixos-laptop
              HostName nixos-laptop
              User ${username}
              Port 6777
            Host Unraid
              HostName crusader
              User root
              Port 6777
            Host nixos-unraid
              HostName 10.20.1.112
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
            Host MiSTer
              HostName 10.20.1.29
              User root
            Host Mumble
              HostName game-central.party
              User ${username}
              Port 6777
            Host unifi-CKG2
              HostName unifi
              User keenanweaver
            Host hellcatv.xyz
              HostName hellcatv.xyz
              User ${username}
              Port 6777
            Host opnsense
              HostName opnsense
              User ${username}
              Port 6777
            Host steamdeck
              HostName steamdeck
              User deck
          '';
        };
      };
  };
}
