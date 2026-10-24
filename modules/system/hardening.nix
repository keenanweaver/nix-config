{ inputs, ... }:
{
  flake.modules.nixos.profile-base =
    { lib, ... }:
    {
      imports = [ inputs.nix-mineral.nixosModules.nix-mineral ];
      boot = {
        consoleLogLevel = lib.mkDefault 0;
        kernelParams = [
          "quiet"
          "udev.log_level=3"
        ];
      };
      nix-mineral = {
        enable = true;
        filesystems.normal = {
          "/etc".enable = false;
          "/home".enable = false;
          "/var".enable = false;
          "/var/lib".enable = false;
          "/var/log".enable = false;
        };
        kernel-modules = {
          enable = true;
          disable = {
            algif-related = false;
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
            thunderbolt = false;
            udf = false; # PS3 games
          };
        };
        preset = [
          "compatibility"
          "performance"
        ];
        settings = {
          debug.quiet-boot = false; # TODO: Revert when fixed
          kernel.iommu-passthrough = false;
          misc.nix-wheel = true;
          network.random-mac = false;
        };
      };
      security = {
        polkit.extraConfig = ''
          polkit.addRule(function(action, subject) {
              if (subject.isInGroup("wheel")) {
                  if (action.id.startsWith("org.freedesktop.udisks2.")) {
                      return polkit.Result.YES;
                  }
              }
          });
        '';
        sudo = {
          execWheelOnly = true;
          extraConfig = "Defaults !lecture,!pwfeedback";
        };
      };
      services.fail2ban.enable = true;
    };
  flake-file.inputs.nix-mineral = {
    inputs = {
      flake-compat.follows = "flake-compat";
      flake-parts.follows = "flake-parts";
      nixpkgs.follows = "nixpkgs";
    };
    url = "github:cynicsketch/nix-mineral";
  };
}
