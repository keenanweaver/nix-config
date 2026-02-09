{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.helix;
in
{
  options.helix = {
    enable = lib.mkEnableOption "Enable Helix in home-manager";
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} =
      { pkgs, ... }:
      {
        programs.helix = {
          enable = true;
          extraPackages = with pkgs; [
            bash-language-server
            biome
            docker-compose-language-service
            marksman
            nixd
            nixfmt
            nodePackages.prettier
            pgformatter
            (python3.withPackages (
              p:
              (with p; [
                black
                isort
                python-lsp-black
                python-lsp-server
              ])
            ))
            ruff
            rust-analyzer
            shellcheck
            shfmt
            taplo
            terraform-ls
            vscode-langservers-extracted
            wl-clipboard
            yaml-language-server
          ];
          languages = {
            language-server = {
              biome = {
                command = "biome";
                args = [ "lsp-proxy" ];
              };
              json = {
                command = "vscode-json-languageserver";
                args = [ "--stdio" ];
              };
              nixd = {
                command = "nixd";
              };
              pylyzer = {
                command = "pylyzer";
                args = [ "--server" ];
              };
              ruff = {
                command = "ruff";
                args = [
                  "server"
                  "-q"
                  "--preview"
                ];
              };
              taplo = {
                command = "taplo";
                args = [
                  "lsp"
                  "stdio"
                ];
              };
              yaml = {
                command = "yaml-language-server";
                args = [ "--stdio" ];
              };
            };
            language = [
              {
                name = "bash";
                language-servers = [ "bash-language-server" ];
                formatter = {
                  command = "shfmt";
                  args = [
                    "-i"
                    "2"
                    "-"
                  ];
                };
                auto-format = true;
              }
              {
                name = "css";
                language-servers = [
                  "vscode-css-language-server"
                  "gpt"
                ];
                formatter = {
                  command = "prettier";
                  args = [
                    "--stdin-filepath"
                    "file.css"
                  ];
                };
                auto-format = true;
              }
              {
                name = "html";
                language-servers = [
                  "vscode-html-language-server"
                  "gpt"
                ];
                formatter = {
                  command = "prettier";
                  args = [
                    "--stdin-filepath"
                    "file.html"
                  ];
                };
                auto-format = true;
              }
              {
                name = "json";
                language-servers = [
                  {
                    name = "vscode-json-language-server";
                    except-features = [ "format" ];
                  }
                  "biome"
                ];
                formatter = {
                  command = "biome";
                  args = [
                    "format"
                    "--indent-style"
                    "space"
                    "--stdin-file-path"
                    "file.json"
                  ];
                };
                auto-format = true;
              }
              {
                name = "markdown";
                language-servers = [
                  "marksman"
                  "gpt"
                ];
                formatter = {
                  command = "prettier";
                  args = [
                    "--stdin-filepath"
                    "file.md"
                  ];
                };
                auto-format = true;
              }
              {
                name = "nix";
                language-servers = [
                  "nixd"
                  "nixfmt"
                ];
                formatter = {
                  command = "nixfmt";
                };
                auto-format = true;
              }
              {
                name = "python";
                language-servers = [
                  "pylyzer"
                  "ruff"
                  "gpt"
                ];
                formatter = {
                  command = "ruff";
                  args = [
                    "format"
                    "-"
                  ];
                };
                auto-format = true;
              }
              {
                name = "sql";
                language-servers = [ "gpt" ];
                formatter = {
                  command = "pg_format";
                  args = [
                    "-iu1"
                    "--no-space-function"
                    "-"
                  ];
                };
                auto-format = true;
              }
              {
                name = "toml";
                language-servers = [ "taplo" ];
                formatter = {
                  command = "taplo";
                  args = [
                    "fmt"
                    "-o"
                    "column_width=120"
                    "-"
                  ];
                };
                file-types = [
                  ".editorconfig"
                  "toml"
                ];
                auto-format = true;
              }
              {
                name = "yaml";
                language-servers = [ "yaml-language-server" ];
                formatter = {
                  command = "prettier";
                  args = [
                    "--stdin-filepath"
                    "file.yaml"
                  ];
                };
                auto-format = true;
              }
            ];
          };
          settings = {
            editor = {
              auto-format = true;
              auto-pairs = true;
              bufferline = "multiple";
              color-modes = true;
              cursor-shape = {
                insert = "bar";
                normal = "block";
                select = "underline";
              };
              cursorcolumn = true;
              cursorline = true;
              file-picker = {
                follow-symlinks = true;
                git-ignore = true;
                git-global = true;
                hidden = false;
                ignore = false;
              };
              gutters = [
                "diagnostics"
                "line-numbers"
                "spacer"
                "diff"
              ];
              indent-guides = {
                render = true;
                rainbow-option = "dim";
              };
              line-number = "relative";
              lsp = {
                enable = true;
                display-inlay-hints = true;
                display-messages = true;
                snippets = true;
              };
              popup-border = "all";
              shell = [
                "zsh"
                "-c"
              ];
              smart-tab = {
                enable = true;
              };
              soft-wrap = {
                enable = true;
              };
              statusline = {
                left = [
                  "mode"
                  "file-name"
                  "spinner"
                  "read-only-indicator"
                  "file-modification-indicator"
                ];
                right = [
                  "diagnostics"
                  "selections"
                  "register"
                  "file-type"
                  "file-line-ending"
                  "position"
                ];
              };
              true-color = true;
            };
            keys = {
              insert = {
                C-u = [
                  "extend_to_line_bounds"
                  "delete_selection_noyank"
                  "open_above"
                ];
                C-w = [
                  "move_prev_word_start"
                  "delete_selection_noyank"
                ];
                C-space = "completion";
                S-tab = "move_parent_node_start";
                j = {
                  k = "normal_mode";
                };
              };
              normal = {
                space = {
                  A-f = ":toggle auto-format";
                  W = [
                    ":toggle soft-wrap.enable"
                    ":redraw"
                  ];
                  Q = ":quit!";
                  c = ":buffer-close";
                  e = ":config-open";
                  f = ":format";
                  q = ":quit";
                  w = ":write";
                  space = "file_picker";
                };
                esc = [
                  "collapse_selection"
                  "keep_primary_selection"
                ];
                C-k = [
                  "extend_to_line_bounds"
                  "delete_selection"
                  "move_line_up"
                  "paste_before"
                ];
                C-j = [
                  "extend_to_line_bounds"
                  "delete_selection"
                  "paste_after"
                ];
                C-r = ":reload";
                C-h = ":toggle-option lsp.display-inlay-hints";
              };
              select = {
                g = {
                  j = "goto_last_line";
                  k = "goto_file_start";
                };
              };
            };
          };
        };
      };
  };
}
