{
  flake.modules.homeManager.profile-desktop.home.shellAliases = {
    db = "distrobox";
    dbe = "db enter";
    lgog = "lgogdownloader --download --exclude l,p --platform=w --directory /mnt/crusader/Games/Backups/GOG";
    npr = "nixpkgs-review pr --print-result";
    psr = "plasmashell --replace & disown";
    repw = "systemctl --user restart pipewire{,-pulse} wireplumber && gsr-ui-cli toggle-replay && gsr-ui-cli toggle-replay";
  };
}
