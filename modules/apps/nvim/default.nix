{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.nvim;
in
{
  options = {
    nvim = {
      enable = lib.mkEnableOption "Enable nvim in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} =
      { pkgs, ... }:
      {
        programs.nvf = {
          enable = true;
          enableManpages = true;
          settings = {
            vim = {
              extraPackages = with pkgs; [
                ansible-language-server
                ansible-lint
                bash-language-server
                shellcheck
                shellharden
                shfmt
                docker-compose-language-service
                dockerfile-language-server-nodejs
                vscode-langservers-extracted
                lua-language-server
                marksman
                (python3.withPackages (
                  p:
                  (with p; [
                    black
                    isort
                    python-lsp-black
                    python-lsp-server
                  ])
                ))
                terraform-ls
                taplo-lsp
                nodePackages.yaml-language-server
                yamllint
                lemminx
              ];
              autocomplete.nvim-cmp.enable = true;
              binds = {
                cheatsheet.enable = true;
                whichKey = {
                  enable = true;
                };
              };
              comments = {
                comment-nvim = {
                  enable = true;
                };
              };
              dashboard = {
                dashboard-nvim = {
                  enable = true;
                };
              };
              debugger = {
                nvim-dap = {
                  enable = true;
                };
              };
              filetree = {
                neo-tree = {
                  enable = true;
                };
              };
              /*
                fzf-lua = {
                             enable = true;
                           };
              */
              gestures = {
                gesture-nvim = {
                  enable = true;
                };
              };
              git = {
                enable = true;
              };
              keymaps = [
                {
                  key = "<C-s>";
                  mode = [
                    "i"
                    "x"
                    "n"
                    "s"
                  ];
                  desc = "Save File";
                  action = "<cmd>w<cr><esc>";
                }
              ];
              languages = {
                enableDAP = true;
                enableExtraDiagnostics = true;
                enableFormat = true;
                enableLSP = true;
                enableTreesitter = true;
                bash = {
                  enable = true;
                };
                css = {
                  enable = true;
                };
                go = {
                  enable = true;
                };
                html = {
                  enable = true;
                };
                lua = {
                  enable = true;
                  lsp.lazydev.enable = true;
                };
                markdown = {
                  enable = true;
                  extensions = {
                    render-markdown-nvim = {
                      enable = true;
                    };
                  };
                };
                nix = {
                  enable = true;
                  format.type = "nixfmt";
                };
                nu = {
                  enable = true;
                };
                php = {
                  enable = true;
                };
                python = {
                  enable = true;
                };
                rust = {
                  enable = true;
                  crates = {
                    enable = true;
                  };
                };
                sql = {
                  enable = true;
                };
                terraform = {
                  enable = true;
                };
                ts = {
                  enable = true;
                  extensions = {
                    ts-error-translator = {
                      enable = true;
                    };
                  };
                };
                zig = {
                  enable = true;
                };
              };
              lazy = {
                enable = true;
              };
              lsp = {
                enable = true;
                lspSignature = {
                  enable = true;
                };
                lspconfig = {
                  enable = true;
                };
                lspkind = {
                  enable = true;
                };
                mappings = {
                  format = "<C-f>";
                };
                lspsaga = {
                  enable = true;
                };
                null-ls = {
                  enable = true;
                };
                nvim-docs-view = {
                  enable = true;
                };
                otter-nvim = {
                  enable = true;
                };
                trouble = {
                  enable = true;
                };
              };
              minimap.codewindow.enable = true;
              notes = {
                neorg = {
                  enable = true;
                };
                todo-comments = {
                  enable = true;
                };
              };
              notify = {
                nvim-notify = {
                  enable = true;
                };
              };
              projects = {
                project-nvim = {
                  enable = true;
                };
              };
              runner = {
                run-nvim = {
                  enable = true;
                };
              };
              session = {
                nvim-session-manager = {
                  enable = true;
                };
              };
              snippets = {
                luasnip = {
                  enable = true;
                };
              };
              spellcheck = {
                enable = true;
              };
              options = {
                tabstop = 2;
                shiftwidth = 2;
                softtabstop = 2;
              };
              preventJunkFiles = true;
              statusline.lualine.enable = true;
              syntaxHighlighting = true;
              telescope.enable = true;
              terminal = {
                toggleterm = {
                  enable = true;
                  lazygit = {
                    enable = true;
                  };
                };
              };
              treesitter = {
                enable = true;
                context = {
                  enable = true;
                };
                fold = true;
                highlight = {
                  enable = true;
                };
                indent = {
                  enable = true;
                };
              };
              ui = {
                colorizer.enable = true;
                breadcrumbs = {
                  enable = true;
                  lualine.winbar.alwaysRender = true;
                  navbuddy.enable = true;
                };
                borders = {
                  enable = true;
                };
                illuminate.enable = true;
                modes-nvim.enable = true;
                noice.enable = true;
                nvim-ufo = {
                  enable = true;
                };
                smartcolumn = {
                  enable = true;
                };
              };
              useSystemClipboard = true;
              utility = {
                diffview-nvim.enable = true;
                preview = {
                  glow = {
                    enable = true;
                  };
                  markdownPreview = {
                    enable = true;
                  };
                };
                surround.enable = true;
              };
              viAlias = true;
              vimAlias = true;
              visuals = {
                cellular-automaton = {
                  enable = true;
                };
                cinnamon-nvim = {
                  enable = true;
                };
                fidget-nvim = {
                  enable = true;
                };
                highlight-undo = {
                  enable = true;
                };
                indent-blankline = {
                  enable = true;
                };
                nvim-cursorline = {
                  enable = true;
                };
                nvim-scrollbar = {
                  enable = true;
                };
                nvim-web-devicons = {
                  enable = true;
                };
                rainbow-delimiters = {
                  enable = true;
                };
              };
              withPython3 = true;
            };
          };
        };
      };
  };
}
