{
  flake.modules.nixos.base-profile = { pkgs, ... }: {
    users = {
      defaultUserShell = pkgs.zsh;
      mutableUsers = true;
    };
  };
}
