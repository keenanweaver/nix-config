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
              fzf-lua = {
                enable = true;
              };
              gestures = {
                gesture-nvim = {
                  enable = true;
                };
              };
              git = {
                enable = true;
              };
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
                  lsp.neodev.enable = true;
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
                lightbulb = {
                  enable = true;
                }; 
                lspSignature = {
                  enable = true;
                };
                lspconfig = {
                  enable = true;
                };
                lspkind = {
                  enable = true;
                };
                lsplines = {
                  enable = true;
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
                orgmode = {
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
                preview = {
                  glow = {
                    enable = true;
                  };
                  markdownPreview = {
                    enable = true;
                  };
                };
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
        programs.nixvim = {
          enable = false;
          extraConfigLua = ''
            local Terminal  = require('toggleterm.terminal').Terminal
            local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

            function _lazygit_toggle()
              lazygit:toggle()
            end
          '';
          extraPlugins = with pkgs.vimPlugins; [
            vim-just
            vim-nixhash
            vim-nix
            zoxide-vim
            {
              plugin = dressing-nvim;
              config = ''lua require('dressing').setup()'';
            }
            {
              plugin = overseer-nvim;
              config = ''lua require('overseer').setup({ task_list = { direction = "bottom" } })'';
            }
          ];
          opts = {
            number = true;
            relativenumber = true;
            tabstop = 2;
            shiftwidth = 2;
            expandtab = true;
            softtabstop = 2;
          };
          plugins = {
            bufferline.enable = true;
            cmp = {
              # Completion https://github.com/hrsh7th/nvim-cmp
              enable = true;
              autoEnableSources = true;
              settings = {
                sources = [
                  { name = "nvim_lsp"; }
                  { name = "path"; }
                  { name = "buffer"; }
                ];
                snippet = {
                  expand = "luasnip";
                };
                mappingPresets = [ "insert" ];
                mapping = {
                  "<CR>" = "cmp.mapping.confirm({ select = true })";
                  "<C-space>" = "cmp.mapping.complete()";
                  "<C-b>" = "cmp.mapping.scroll_docs(-4)";
                  "<C-f>" = "cmp.mapping.scroll_docs(4)";
                };
              };
            };
            codeium-nvim.enable = true; # AI assistant https://github.com/Exafunction/codeium.vim
            codeium-vim.enable = true; # AI assistant https://github.com/Exafunction/codeium.vim
            colorizer.enable = true;
            comment.enable = true; # Toggle comments https://github.com/terrortylor/nvim-comment
            friendly-snippets.enable = true; # Snippets https://github.com/rafamadriz/friendly-snippets
            gitsigns.enable = true; # Git decorations https://github.com/lewis6991/gitsigns.nvim
            lsp = {
              enable = true;
              servers = {
                ansiblels = {
                  enable = true;
                  autostart = true;
                };
                bashls = {
                  enable = true;
                  autostart = true;
                };
                dockerls = {
                  enable = true;
                  autostart = true;
                };
                gopls = {
                  enable = true;
                  autostart = true;
                };
                html = {
                  enable = true;
                  autostart = true;
                };
                lemminx = {
                  enable = true;
                  autostart = true;
                };
                lua_ls = {
                  enable = true;
                  autostart = true;
                };
                marksman = {
                  enable = true;
                  autostart = true;
                };
                nixd = {
                  enable = true;
                  autostart = true;
                  extraOptions.settings = {
                    nixd = {
                      nixpkgs = {
                        expr = "import <nixpkgs> { }";
                      };
                    };
                    options = {
                      nixos = {
                        expr = ''(builtins.getFlake \"github:keenanweaver/nix-config\").nixosConfigurations.${config.networking.hostName}.options'';
                      };
                    };
                  };
                };
                ruff_lsp = {
                  enable = true;
                  autostart = true;
                };
                terraformls = {
                  enable = true;
                  autostart = true;
                };
              };
            };
            lsp-format.enable = true; # Formatting https://github.com/lukas-reineke/lsp-format.nvim
            lualine = {
              # Status line https://github.com/nvim-lualine/lualine.nvim
              enable = true;
              settings.sections.lualine_x = [ "overseer" ];
            };
            luasnip.enable = true; # Lua snippets https://github.com/L3MON4D3/LuaSnip
            neo-tree = {
              # Filesystem https://github.com/nvim-neo-tree/neo-tree.nvim
              enable = true;
              enableGitStatus = true;
            };
            rustaceanvim.enable = true; # https://github.com/mrcjkb/rustaceanvim
            todo-comments.enable = true; # Highlight todo comments https://github.com/folke/todo-comments.nvim
            toggleterm.enable = true; # Terminal manager https://github.com/akinsho/toggleterm.nvim
            transparent.enable = true; # Transparency https://github.com/xiyaowong/transparent.nvim/
            treesitter.enable = true;
            treesitter-refactor.enable = true;
            web-devicons.enable = true;
            which-key.enable = true; # Key bindings https://github.com/folke/which-key.nvim
          };
        };
      };
  };
}
