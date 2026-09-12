{
  flake.modules.nixos =
    let
      nfsMounts =
        { lib, pkgs, ... }:
        {
          environment.systemPackages = with pkgs; [
            cifs-utils
            nfs-utils
          ];
          fileSystems = builtins.listToAttrs (
            map
              (mount: {
                name = "/mnt/crusader/${mount}";
                value = {
                  device = "crusader:/mnt/user/${mount}";
                  fsType = "nfs";
                  options = [
                    "_netdev"
                    "hard"
                    "noauto"
                    "noatime"
                    "nofail"
                    "x-systemd.automount"
                    "x-systemd.idle-timeout=60"
                    "x-systemd.mount-timeout=10s"
                  ];
                };
              })
              [
                "Backup"
                "Downloads"
                "Games"
                "Life"
                "Media"
                "Miscellaneous"
                "Photos"
                "Projects"
              ]
          );
          services.rpcbind.enable = true;
          systemd.services.force-umount-nfs = {
            wantedBy = [ "multi-user.target" ];
            before = [
              "network.target"
              "shutdown.target"
            ];
            serviceConfig = {
              ExecStop = "${lib.getExe' pkgs.util-linux "umount"} -f -l -a -t nfs,nfs4";
              RemainAfterExit = true;
              Type = "oneshot";
            };
          };
        };
    in
    {
      profile-desktop = nfsMounts;
      profile-pi = nfsMounts;
    };
}
