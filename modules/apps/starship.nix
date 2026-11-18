{
  flake.modules.homeManager.profile-base =
    { lib, config, ... }:
    {
      programs.starship = {
        enable = true;
        settings =
          lib.recursiveUpdate
            (lib.importTOML "${config.programs.starship.package.src}/docs/public/presets/toml/nerd-font-symbols.toml")
            {
              add_newline = true;
              character = {
                error_symbol = "[⮞](bold red)";
                success_symbol = "[⮞](bold lavender)";
              };
              cmd_duration = {
                format = "[ $duration]($style)";
                min_time = 1000;
                min_time_to_notify = 60000;
                show_notifications = true;
                style = "yellow";
              };
              continuation_prompt = "[╰╴](lavender)[⋯ ](overlay1)";
              directory = {
                substitutions = {
                  "/mnt/crusader/Projects" = "󰉋 proj";
                  "󰉋 proj/Codeberg" = " cb";
                };
                truncation_symbol = "…/";
              };
              env_var.WINEPREFIX = {
                format = "[🍷 $env_value]($style) ";
                style = "bold maroon";
              };
              fill.symbol = " ";
              format = lib.concatStrings [
                "[╭╴](lavender)$os$container$shell$fill$time\n"
                "[├╴](lavender)$all"
                "[╰╴](lavender)$jobs$status$character"
              ];
              git_commit = {
                only_detached = true;
                tag_disabled = false;
              };
              git_metrics.disabled = false;
              git_status = {
                ahead = "⇡\${count}";
                behind = "⇣\${count}";
                diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
              };
              localip = {
                disabled = false;
                ssh_only = true;
              };
              nix_shell = {
                format = "via [$symbol$state( \\($name\\))]($style) ";
                heuristic = true;
                style = "bold sapphire";
              };
              os.disabled = false;
              right_format = "$cmd_duration";
              shell = {
                disabled = false;
                zsh_indicator = "";
              };
              status = {
                disabled = false;
                format = "[$symbol$status]($style) ";
              };
              sudo.disabled = false;
              time = {
                disabled = false;
                format = "[ $time]($style)";
                style = "overlay1";
                time_format = "%H:%M";
              };
              username.style_root = "red bold";
            };
      };
    };
}
