{
  flake.modules.homeManager.profile-base.programs.fzf = {
    enable = true;
    defaultCommand = "fd --type f";
    fileWidget.options = [ "--preview bat -pp --color=always {}" ];
    historyWidget.command = "";
  };
}
