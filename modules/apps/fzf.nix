{
  flake.modules.homeManager.profile-base.programs.fzf = {
    enable = true;
    defaultCommand = "fd --type f";
    enableBashIntegration = true;
    enableZshIntegration = true;
    fileWidget.options = [ "--preview bat -pp --color=always {}" ];
    historyWidget.command = "";
  };
}
