{
  flake.modules.nixos.profile-base =
    { pkgs, ... }:
    {
      users = {
        defaultUserShell = pkgs.zsh;
        mutableUsers = true;
      };
    };
}
