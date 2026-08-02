{
  configurations.nixos.nixos-desktop.module =
    { lib, config, ... }:
    {
      home-manager.users.${config.my.user} = { config, osConfig, ... }: {
        programs =
          let
            custompath = ''
              if [ "''${CONTAINER_ID:-}" = "exodos" ]; then
                  PATH=${config.xdg.dataHome}/distrobox/exodos/dosbox:${config.xdg.dataHome}/distrobox/exodos/dbgl:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/opt/rocm/bin:/var/lib/flatpak/exports/bin:${config.home.homeDirectory}/.local/share/flatpak/exports/bin:${config.home.homeDirectory}/.bin:${config.home.homeDirectory}/.local/bin:${config.home.homeDirectory}/bin:/run/wrappers/bin:${config.home.homeDirectory}/.nix-profile/bin:/nix/profile/bin:${config.home.homeDirectory}/.local/state/nix/profile/bin:/etc/profiles/per-user/${osConfig.my.user}/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:${config.home.homeDirectory}/.config/zsh/plugins/cd-ls:${config.home.homeDirectory}/.config/zsh/plugins/zsh-fast-syntax-highlighting:${config.home.homeDirectory}/.config/zsh/plugins/nix-zsh-completions
              fi'';
          in
          {
            bash.initExtra = lib.mkAfter ''
              ${custompath}
            '';

            distrobox = {
              containers.exodos = {
                image = "docker.io/library/ubuntu:24.04";
                init = true;
              };

              enableSystemdUnit = true;
              settings.container_additional_volumes = "/nix/store:/nix/store:ro /etc/profiles/per-user:/etc/profiles/per-user:ro /etc/static/profiles/per-user:/etc/static/profiles/per-user:ro";
            };

            zsh.initContent = lib.mkAfter ''
              ${custompath}
            '';
          };
      };
    };
}
