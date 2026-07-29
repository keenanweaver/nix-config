{
  configurations.nixos.nixos-laptop.module =
    { config, ... }:
    {
      home-manager.users.${config.my.user} =
        { pkgs, ... }:
        {
          home.packages = with pkgs; [
            bash-language-server
            # Dev #
            codeium
            ## Nix ##
            comma
            deadnix
            haruna
            just
            kdePackages.neochat
            manix
            mdformat
            nix-inspect
            nix-update
            nixd
            nixfmt
            nixos-shell
            nixpkgs-review
            nvd
            optnix
            powershell
            rssguard
            seer
            shellcheck
            shellharden
            shfmt
            signal-desktop
            statix
          ];
        };
    };
}
