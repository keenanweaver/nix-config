{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.zsh;
in
{
  options = {
    zsh = {
      enable = lib.mkEnableOption "Enable zsh in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
    };
    home-manager.users.${username} =
      {
        inputs,
        config,
        pkgs,
        ...
      }:
      {
        programs.zsh = {
          enable = true;
          autosuggestion.enable = true;
          dotDir = ".config/zsh";
          history = {
            path = "${config.xdg.dataHome}/zsh/zsh_history";
            size = 999999999;
            extended = true;
            ignoreSpace = true;
          };
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
          plugins = [
            {
              name = "cd-ls";
              src = inputs.cd-ls;
              file = "cd-ls.plugin.zsh";
            }
            {
              name = "zsh-fast-syntax-highlighting";
              src = pkgs.zsh-fast-syntax-highlighting;
              file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
            }
            {
              name = "nix-zsh-completions";
              src = pkgs.nix-zsh-completions;
              file = "share/zsh/site-functions/nix-zsh-completions.plugin.zsh";
            }
          ];
        };
      };
  };
}
