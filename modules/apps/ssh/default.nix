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
      enableAskPassword = true;
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
        home.packages = with pkgs; [
          lazyssh
          sshs
        ];
        home.sessionVariables = {
          SSH_ASKPASS = lib.getExe pkgs.kdePackages.ksshaskpass;
          SSH_ASKPASS_REQUIRE = "prefer";
        };
        programs.ssh = {
          enable = true;
          enableDefaultConfig = false;
          matchBlocks = {
            "*" = {
              addKeysToAgent = "yes";
            };
            bazzite = {
              hostname = "bazzite";
              user = "bazzite";
            };
            mister = {
              hostname = "mister";
              user = "root";
            };
            mumble = {
              hostname = "game-central.party";
              port = 6777;
            };
            nixos-desktop = {
              hostname = "nixos-desktop";
              port = 6777;
            };
            bazzite-htpc = {
              hostname = "bazzite-htpc";
            };
            nixos-laptop = {
              hostname = "nixos-laptop";
              port = 6777;
            };
            nix-unraid = {
              hostname = "nix-unraid";
              port = 22;
            };
            opnsense = {
              hostname = "opnsense";
            };
            regretpi = {
              hostname = "regretpi";
              port = 6777;
            };
            remorsepi = {
              hostname = "remorsepi";
              port = 6777;
            };
            unifi-CKG2 = {
              hostname = "unifi";
              port = 6777;
              user = "keenanweaver";
            };
            unraid = {
              hostname = "crusader";
              port = 6777;
              user = "root";
            };
          };
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
