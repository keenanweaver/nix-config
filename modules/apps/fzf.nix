{
  flake.modules.homeManager.base-profile = {
    programs.fzf = {
      enable = true;
      defaultCommand = "fd --type f";
      enableBashIntegration = true;
      enableZshIntegration = true;
      fileWidget.options = [ "--preview bat -pp --color=always {}" ];
      historyWidget.command = "";
    };
  };
}
