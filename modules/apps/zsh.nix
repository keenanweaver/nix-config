{
  flake.modules = {
    homeManager.base-profile =
      {
        lib,
        config,
        pkgs,
        ...
      }:
      {
        programs.zsh = {
          enable = true;
          autosuggestion.enable = true;
          dotDir = "${config.xdg.configHome}/zsh";

          history = {
            extended = true;
            ignoreSpace = true;
            size = 999999999;
          };

          initContent = ''
            chpwd() {
              lsd -la
            }
            ${lib.getExe pkgs.any-nix-shell} zsh --info-right | source /dev/stdin

            if [[ -n "$SSH_CONNECTION" ]]; then
              gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1
            fi
          '';

          oh-my-zsh = {
            enable = true;
            custom = "${config.xdg.configHome}/zsh/.zsh_custom";

            plugins = [
              "command-not-found"
              "direnv"
              "git"
              "sudo"
              "zsh-interactive-cd"
            ];
          };

          syntaxHighlighting.enable = true;
        };
      };

    nixos.base-profile.programs.zsh.enable = true;
  };
}
