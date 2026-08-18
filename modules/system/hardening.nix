{
  flake.modules.nixos.base-profile =
    { inputs, config, ... }:
    {
      imports = [ inputs.nix-mineral.nixosModules.nix-mineral ];
      nix-mineral = {
        enable = true;
        filesystems.normal."/home".enable = false;
        kernel-modules.disable = {
          auth_rpcgss = false;
          cdrom-related = false;
          grace = false;
          intelme-related = true;
          joystick-drivers = false;
          lockd = false;
          nfs = false;
          nfs_acl = false;
          nfs_layout_flexfiles = false;
          nfs_layout_nfsv41_files = false;
          nfs_localio = false;
          nfsd = false;
          nfsv3 = false;
          nfsv4 = false;
          rpcsec_gss_krb5 = false;
          sunrpc = false;
          udf = false; # PS3 games
        };
        preset = [
          "compatibility"
          "performance"
        ];
        settings = {
          kernel.strict-iommu = false; # if true, boot doesn't work
          misc.nix-wheel = true;
          network.random-mac = false;
        };
      };
      security = {
        pam.sshAgentAuth.enable = true;
        polkit = {
          # UDisks https://gist.github.com/Scrumplex/8f528c1f63b5f4bfabe14b0804adaba7
          extraConfig = ''
            polkit.addRule(function(action, subject) {
                if (subject.isInGroup("wheel")) {
                    if (action.id.startsWith("org.freedesktop.udisks2.")) {
                        return polkit.Result.YES;
                    }
                }
            });
          '';
        };
        sudo = {
          execWheelOnly = true;
          extraConfig = "Defaults !lecture,!pwfeedback";
          extraRules = [
            {
              commands =
                map
                  (command: {
                    command = "/run/current-system/sw/bin/${command}";
                    options = [ "NOPASSWD" ];
                  })
                  [
                    "poweroff"
                    "reboot"
                    "nixos-rebuild"
                    "nix-env"
                    "shutdown"
                    "systemctl"
                  ];
              users = [ "${config.my.user}" ];
            }
          ];
        };
      };
      services.fail2ban.enable = true;
    };
  flake-file.inputs.nix-mineral = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:cynicsketch/nix-mineral";
  };
}
