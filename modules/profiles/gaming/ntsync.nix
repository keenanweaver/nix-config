{
  flake.modules.nixos.gaming-profile = { pkgs, ... }: {
    boot.kernelModules = [
      "ntsync"
    ];
    services.udev.packages = [
      (pkgs.writeTextFile {
        destination = "/etc/udev/rules.d/70-ntsync.rules";
        name = "ntsync-udev-rule";
        text = ''
          KERNEL=="ntsync", MODE="0660", TAG+="uaccess"
        '';
      })
    ];
  };
}
