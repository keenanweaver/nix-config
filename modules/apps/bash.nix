{
  flake.modules = {
    homeManager.base-profile =
      { config, ... }:
      {
        programs.bash = {
          enable = true;
          historyFile = "${config.xdg.dataHome}/bash/.bash_history";

          initExtra = ''
            cd() {
              builtin cd "$@" && lsd -la
            }

            if [[ -n "$SSH_CONNECTION" ]]; then
              gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1
            fi
          '';
        };
      };

    nixos.base-profile.programs.bash.blesh.enable = true;
  };
}
