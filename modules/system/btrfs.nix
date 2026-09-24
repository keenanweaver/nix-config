{
  flake.modules.nixos.btrfs.services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
  };
}
