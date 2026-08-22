{
  flake.modules = {
    homeManager.profile-base =
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
    nixos.profile-base.programs.zsh.enable = true;
  };
}
