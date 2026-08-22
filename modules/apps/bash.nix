{
  flake.modules = {
    homeManager.profile-base =
      { config, ... }:
      {
        programs.bash = {
          enable = true;
          historyFile = "${config.xdg.dataHome}/bash/.bash_history";
          initExtra = ''
            cd() {
              builtin cd "$@" && lsd -la
            }
          '';
        };
      };
    nixos.profile-base.programs.bash.blesh.enable = true;
  };
}
