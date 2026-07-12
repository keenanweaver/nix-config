{
  flake.modules.homeManager.base-profile = { config, ... }: {
    home.shellAliases = {
      b = "bat --color=always -pp";
      bb = "bat --color=always";
      db = "distrobox";
      dbe = "db enter";
      imp = "lsd --one-file-system --base-directory / -t f -H -E '{tmp,etc/passwd,var/lib/systemd/coredump}'"; # https://reddit.com/r/NixOS/comments/1nhm4mm/tailscale_impermanence_broken/nedm0vd/?context=3#nedm0vd
      j = "just --justfile $NH_FLAKE/Justfile";
      l = "lsd -la --group-dirs=first";
      lgog = "lgogdownloader --download --exclude l,p --platform=w --directory /mnt/crusader/Games/Backups/GOG";
      ngc = "nh clean all";
      nor = "nh os boot";
      npr = "nixpkgs-review pr --print-result";
      psr = "plasmashell --replace & disown";
      rbn = "podman stop -a && systemctl reboot";
      repw = "systemctl --user restart pipewire{,-pulse} wireplumber && gsr-ui-cli toggle-replay && gsr-ui-cli toggle-replay";
      upd = "topgrade";
      wget = "wget --hsts-file=${config.xdg.dataHome}/wget-hsts";
    };
  };
}
