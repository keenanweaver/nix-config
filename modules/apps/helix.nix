{
  flake.modules.homeManager.base-profile = { pkgs, ... }: {
    programs.helix = {
      enable = true;
      extraPackages = with pkgs; [
        bash-language-server
        biome
        docker-compose-language-service
        marksman
        nixd
        nixfmt
        pgformatter
        #(python3.withPackages (
        #  p:
        #  (with p; [
        #    black
        #    isort
        #    python-lsp-black
        #    python-lsp-server
        #  ])
        #))
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
        language = [
          {
            auto-format = true;
            formatter = {
              args = [
                "-i"
                "2"
                "-"
              ];
              command = "shfmt";
            };
            language-servers = [ "bash-language-server" ];
            name = "bash";
          }
          {
            auto-format = true;
            formatter = {
              args = [
                "--stdin-filepath"
                "file.css"
              ];
              command = "prettier";
            };
            language-servers = [
              "vscode-css-language-server"
              "gpt"
            ];
            name = "css";
          }
          {
            auto-format = true;
            formatter = {
              args = [
                "--stdin-filepath"
                "file.html"
              ];
              command = "prettier";
            };
            language-servers = [
              "vscode-html-language-server"
              "gpt"
            ];
            name = "html";
          }
          {
            auto-format = true;
            formatter = {
              args = [
                "format"
                "--indent-style"
                "space"
                "--stdin-file-path"
                "file.json"
              ];
              command = "biome";
            };
            language-servers = [
              {
                except-features = [ "format" ];
                name = "vscode-json-language-server";
              }
              "biome"
            ];
            name = "json";
          }
          {
            auto-format = true;
            formatter = {
              args = [
                "--stdin-filepath"
                "file.md"
              ];
              command = "prettier";
            };
            language-servers = [
              "marksman"
              "gpt"
            ];
            name = "markdown";
          }
          {
            auto-format = true;
            formatter = {
              command = "nixfmt";
            };
            language-servers = [
              "nixd"
              "nixfmt"
            ];
            name = "nix";
          }
          {
            auto-format = true;
            formatter = {
              args = [
                "format"
                "-"
              ];
              command = "ruff";
            };
            language-servers = [
              "pylyzer"
              "ruff"
              "gpt"
            ];
            name = "python";
          }
          {
            auto-format = true;
            formatter = {
              args = [
                "-iu1"
                "--no-space-function"
                "-"
              ];
              command = "pg_format";
            };
            language-servers = [ "gpt" ];
            name = "sql";
          }
          {
            auto-format = true;
            file-types = [
              ".editorconfig"
              "toml"
            ];
            formatter = {
              args = [
                "fmt"
                "-o"
                "column_width=120"
                "-"
              ];
              command = "taplo";
            };
            language-servers = [ "taplo" ];
            name = "toml";
          }
          {
            auto-format = true;
            formatter = {
              args = [
                "--stdin-filepath"
                "file.yaml"
              ];
              command = "prettier";
            };
            language-servers = [ "yaml-language-server" ];
            name = "yaml";
          }
        ];
        language-server = {
          biome = {
            args = [ "lsp-proxy" ];
            command = "biome";
          };
          json = {
            args = [ "--stdio" ];
            command = "vscode-json-languageserver";
          };
          nixd = {
            command = "nixd";
          };
          pylyzer = {
            args = [ "--server" ];
            command = "pylyzer";
          };
          ruff = {
            args = [
              "server"
              "-q"
              "--preview"
            ];
            command = "ruff";
          };
          taplo = {
            args = [
              "lsp"
              "stdio"
            ];
            command = "taplo";
          };
          yaml = {
            args = [ "--stdio" ];
            command = "yaml-language-server";
          };
        };
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
            git-global = true;
            git-ignore = true;
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
            rainbow-option = "dim";
            render = true;
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
            C-space = "completion";
            C-u = [
              "extend_to_line_bounds"
              "delete_selection_noyank"
              "open_above"
            ];
            C-w = [
              "move_prev_word_start"
              "delete_selection_noyank"
            ];
            S-tab = "move_parent_node_start";
            j = {
              k = "normal_mode";
            };
          };
          normal = {
            C-h = ":toggle-option lsp.display-inlay-hints";
            C-j = [
              "extend_to_line_bounds"
              "delete_selection"
              "paste_after"
            ];
            C-k = [
              "extend_to_line_bounds"
              "delete_selection"
              "move_line_up"
              "paste_before"
            ];
            C-r = ":reload";
            esc = [
              "collapse_selection"
              "keep_primary_selection"
            ];
            space = {
              A-f = ":toggle auto-format";
              Q = ":quit!";
              W = [
                ":toggle soft-wrap.enable"
                ":redraw"
              ];
              c = ":buffer-close";
              e = ":config-open";
              f = ":format";
              q = ":quit";
              space = "file_picker";
              w = ":write";
            };
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
}
