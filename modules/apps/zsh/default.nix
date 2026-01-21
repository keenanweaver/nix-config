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
      { config, pkgs, ... }:
      {
        programs.zsh = {
          enable = true;
          autosuggestion.enable = true;
          dotDir = "${config.xdg.configHome}/zsh";
          history = {
            size = 999999999;
            extended = true;
            ignoreSpace = true;
          };
          initContent = ''
            chpwd() {
              ${lib.getExe pkgs.lsd} -la
            }
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
          syntaxHighlighting = {
            enable = true;
          };
        };
      };
  };
}
