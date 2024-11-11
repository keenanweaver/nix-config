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
        programs.nixvim = {
          enable = true;
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
            nvim-colorizer = {
              # Coloring https://github.com/norcalli/nvim-colorizer.lua
              enable = true;
              userDefaultOptions = {
                css = true;
                tailwind = "both";
              };
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
