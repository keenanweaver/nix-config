{
  flake.modules = {
    homeManager.base-profile = { config, ... }: {
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
    nixos.base-profile = {
      programs.bash = {
        blesh.enable = true;
      };
    };
  };
}
