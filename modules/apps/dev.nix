{
  flake.modules.homeManager.profile-workstation =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        bash-language-server
        codeium
        comma
        deadnix
        just
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
        seer
        shellcheck
        shellharden
        shfmt
        statix
      ];
    };
}
