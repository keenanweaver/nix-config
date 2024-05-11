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
      { config, ... }:
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
        programs.ssh = {
          enable = true;
        };
      };
  };
}
