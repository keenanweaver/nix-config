{
  flake.modules.homeManager.base-profile = { lib, ... }: {
    programs.starship = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
      settings = {
        add_newline = true;
        character = {
          error_symbol = "[⮞](bold red)";
          success_symbol = "[⮞](bold lavender)";
        };
        cmd_duration = {
          format = "[$duration ](fg:yellow)";
          min_time = 1000;
        };
        directory = {
          truncation_symbol = ".../";
        };
        format = lib.concatStrings [
          "[╭╴$symbol](lavender)$os$shell\n"
          "[├](lavender)$all"
          "[╰$symbol](lavender)$character"
        ];
        os = {
          disabled = false;
        };
        shell = {
          disabled = false;
        };
        status = {
          disabled = false;
        };
        username = {
          disabled = false;
          show_always = true;
          style_root = "red bold";
        };
      };
    };
  };
}
