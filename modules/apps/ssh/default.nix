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
    services.fail2ban.enable = true;
    services.openssh = {
      enable = true;
      ports = [ 6777 ];
      settings = {
        AllowUsers = [ "${username}" ];
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    home-manager.users.${username} =
      { pkgs, ... }:
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
              port = 22;
            };
            remorsepi = {
              hostname = "remorsepi";
              port = 22;
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
      };
  };
}
