{
  flake.modules.homeManager.base-profile =
    {
      lib,
      pkgs,
      inputs,
      ...
    }:
    {
      imports = [
        inputs.lazyvim.homeManagerModules.default
      ];

      home.sessionVariables = {
        EDITOR = lib.mkForce "nvim";
      };
      programs.lazyvim = {
        enable = true;
        extraPackages = with pkgs; [
          bash-language-server
          clang
          shellcheck
          shellharden
          shfmt
          docker-compose-language-service
          dockerfile-language-server
          nixd
          nixfmt
          vscode-langservers-extracted
          lua-language-server
          marksman
          tree-sitter
          yamllint
        ];
        extras = {
          ai = {
            claudecode.enable = true;
          };
          coding = {
            blink.enable = true;
            mini-snippets.enable = true;
            mini-surround.enable = true;
            yanky.enable = true;
          };
          formatting = {
            prettier.enable = true;
          };
          lang = {
            cmake.enable = true;
            docker.enable = true;
            git.enable = true;
            json.enable = true;
            nix.enable = true;
            terraform.enable = true;
            toml.enable = true;
            yaml.enable = true;
          };
          linting = {
            eslint.enable = true;
          };
          ui = {
            treesitter-context.enable = true;
          };
          util = {
            gh.enable = true;
            project.enable = true;
            rest.enable = true;
          };
        };
        treesitterParsers = with pkgs.vimPlugins.nvim-treesitter-parsers; [
          awk
          bash
          css
          html
          ini
          jq
          json
          just
          lua
          markdown
          nix
          nu
          python
          regex
          terraform
          toml
          udev
          xml
          xresources
          yaml
          zsh
        ];
      };
    };
  flake.modules.homeManager.nvf =
    {
      lib,
      pkgs,
      inputs,
      ...
    }:
    {
      imports = [
        inputs.nvf.homeManagerModules.default
      ];

      home.sessionVariables = {
        EDITOR = lib.mkForce "nvim";
      };
      programs.nvf = {
        enable = true;
        enableManpages = true;
        settings = {
          vim = {
            extraPackages = with pkgs; [
              bash-language-server
              shellcheck
              shellharden
              shfmt
              docker-compose-language-service
              dockerfile-language-server
              vscode-langservers-extracted
              marksman
              yamllint
            ];
            formatter = {
              conform-nvim = {
                enable = true;
                setupOpts.formatters-by-ft = {
                  nix = [ "nixfmt" ];
                };
              };
            };
            git = {
              enable = true;
            };
            keymaps = [
              {
                action = "<cmd>w<cr><esc>";
                desc = "Save File";
                key = "<C-s>";
                mode = [
                  "i"
                  "x"
                  "n"
                  "s"
                ];
              }
            ];
            languages = {
              bash = {
                enable = true;
              };
              enableDAP = true;
              enableExtraDiagnostics = true;
              enableFormat = true;
              enableTreesitter = true;
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
                lsp.server = "nixd";
              };
            };
            lazy = {
              enable = true;
            };
            lsp = {
              enable = true;
            };
            maps = {
              normal = {
                "<leader>e" = {
                  action = "<cmd>Neotree toggle reveal<cr>";
                  desc = "Toggle Neotree";
                };
              };
            };
            preventJunkFiles = true;
            statusline.lualine.enable = true;
            syntaxHighlighting = true;
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
              borders = {
                enable = true;
              };
              breadcrumbs = {
                enable = true;
                lualine.winbar.alwaysRender = true;
                navbuddy.enable = true;
              };
              colorizer.enable = true;
            };
          };
        };
      };
    };
  flake-file.inputs = {
    lazyvim.url = "github:pfassina/lazyvim-nix";
    nvf = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:notashelf/nvf";
    };
  };
}
