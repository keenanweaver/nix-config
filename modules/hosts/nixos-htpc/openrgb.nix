{
  configurations.nixos.nixos-htpc.module = {
    preservation.preserveAt."/persist".directories = [ "/var/lib/OpenRGB" ];
    services.hardware.openrgb.startupProfile = "htpc";
    systemd.tmpfiles.rules = [
      "d /var/lib/OpenRGB/profiles 0755 root root -"
      "L+ /var/lib/OpenRGB/profiles/htpc.json - - - - ${../../../assets/hosts/nixos-htpc/openrgb.json}"
    ];
  };
}
