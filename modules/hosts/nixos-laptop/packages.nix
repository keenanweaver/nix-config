{
  configurations.nixos.nixos-laptop.module = { config, ... }: {
    home-manager.users.${config.my.user} = { pkgs, ... }: {
      home.packages = with pkgs; [
        haruna
        kdePackages.neochat
        rssguard
        signal-desktop
        # Dev #
        codeium
        just
        mdformat
        powershell
        seer
        bash-language-server
        shellcheck
        shellharden
        shfmt
        ## Nix ##
        comma
        deadnix
        manix
        nixd
        nix-inspect
        nix-update
        nixfmt
        nixpkgs-review
        nixos-shell
        nvd
        statix
        optnix
      ];
    };
  };
}
