{
  flake.modules.homeManager.base-profile = {
    programs.fzf = {
      defaultCommand = "fd --type f";
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      fileWidget.options = [ "--preview bat -pp --color=always {}" ];
      historyWidget.command = "";
    };
  };
}
