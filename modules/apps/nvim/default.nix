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
        home.sessionVariables = {
          EDITOR = lib.mkForce "nvim";
        };
        programs.lazyvim = {
          enable = true;
          extras = {
            ai = {
              claudecode.enable = true;
            };
            coding = {
              blink.enable = true;
              mini_snippets.enable = true;
              mini_surround.enable = true;
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
              none_ls.enable = true;
            };
            ui = {
              treesitter_context.enable = true;
            };
            util = {
              gh.enable = true;
              project.enable = true;
              mini_hipatterns.enable = true;
              rest.enable = true;
            };
          };
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
            nodePackages.yaml-language-server
            tree-sitter
            yamllint
          ];
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
        programs.nvf = {
          enable = false;
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
                nodePackages.yaml-language-server
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
                enableTreesitter = true;
                bash = {
                  enable = true;
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
                    desc = "Toggle Neotree";
                    action = "<cmd>Neotree toggle reveal<cr>";
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
                colorizer.enable = true;
                breadcrumbs = {
                  enable = true;
                  lualine.winbar.alwaysRender = true;
                  navbuddy.enable = true;
                };
                borders = {
                  enable = true;
                };
              };
            };
          };
        };
      };
  };
}
