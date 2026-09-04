{
  flake.modules.homeManager.profile-base =
    { config, ... }:
    {
      home.shellAliases = {
        b = "bat --color=always -pp";
        bb = "bat --color=always";
        imp = "lsd --one-file-system --base-directory / -t f -H -E '{tmp,etc/passwd,var/lib/systemd/coredump}'"; # https://reddit.com/r/NixOS/comments/1nhm4mm/tailscale_impermanence_broken/nedm0vd/?context=3#nedm0vd
        j = "just --justfile $NH_FLAKE/Justfile";
        l = "lsd -la --group-dirs=first";
        ngc = "nh clean all";
        nor = "nh os boot";
        rbn = "podman stop -a && systemctl reboot";
        upd = "topgrade";
        wget = "wget --hsts-file=${config.xdg.dataHome}/wget-hsts";
      };
    };
}
