{ lib, config, username, ... }:
let
  cfg = config.helix;
in
{
  options.helix = {
    enable = lib.mkEnableOption "Enable Helix in home-manager";
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = { pkgs, ... }: {
      programs.helix = {
        enable = true;
        defaultEditor = true;
        extraPackages = with pkgs; [
          # For accessing system clipboard
          wl-clipboard
        ];
        languages = {
          # Update language server settings
          language-server = {
            gopls = {
              command = "gopls";
              config = {
                hints = {
                  assignVariableTypes = true;
                  compositeLiteralFields = true;
                  constantValues = true;
                  functionTypeParameters = true;
                  parameterNames = true;
                  rangeVariableTypes = true;
                };
                gofumpt = true;

                staticcheck = false;

                analyses = {
                  nilness = true;
                  shadow = true;
                  unusedwrite = true;
                  unusedparams = true;
                  useany = true;
                  unusedvariable = true;
                };

                vulncheck = "Imports";
                semanticTokens = true;
              };
            };
            nixd = {
              command = "${pkgs.nixd}/bin/nixd";
            };
            ruff = {
              command = "${pkgs.ruff-lsp}/bin/ruff-lsp";
            };
            rustanalyzer = {
              command = "rust-analyzer";
              args = [ ];
              config = {
                hover.actions.references.enable = true;
                completion.fullFunctionSignatures.enable = true;

                # cargo.extraEnv = {CARGO_TARGET_DIR = "./target/rust_analyzer";};
                check.command = "clippy";
                cargo.features = "all";
                rustc.source = "discover";
                inlayHints.bindingModeHints.enable = true;
                inlayHints.closingBraceHints.minLines = 10;
                inlayHints.closureReturnTypeHints.enable = "with_block";
                inlayHints.discriminantHints.enable = "fieldless";
                inlayHints.lifetimeElisionHints.enable = "skip_trivial";
                inlayHints.typeHints.hideClosureInitialization = false;
              };
            };
            yaml-language-server.config = { yaml.keyOrdering = false; };
          };
          language = [
            {
              name = "bash";
              auto-format = true;
              language-servers = [ "bash-language-server" ];
              formatter = {
                command = "${pkgs.shfmt}/bin/shfmt";
                args = [ "-i" "2" "-" ];
              };
            }
            {
              name = "go";
              auto-format = true;
              language-servers = [ "gopls" ];
              formatter = {
                command = "${pkgs.gofumpt}/bin/gofumpt";
              };
            }
            {
              name = "markdown";
              auto-format = true;
              language-servers = [ "marksman" ];
              formatter = {
                command = "${pkgs.marksman}/bin/marksman";
              };
            }
            {
              name = "nix";
              auto-format = true;
              language-servers = [ "nixd" ];
              formatter = {
                command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
              };
            }
            {
              name = "python";
              auto-format = true;
              language-servers = [ "ruff" ];
              formatter = {
                command = "${pkgs.ruff-lsp}/bin/ruff-lsp";
              };
            }
            {
              name = "rust";
              auto-format = true;
              #language-servers = [ "rust-analyzer" ];
              formatter = {
                command = "${pkgs.rustup}/bin/rustfmt";
              };
            }
            {
              name = "toml";
              file-types = [
                # editorconfig doesn't have .toml extension but is toml
                ".editorconfig"
                "toml"
              ];
            }
            {
              name = "yaml";
              auto-format = true;
              language-servers = [ "yamllint" ];
              formatter = {
                command = "${pkgs.yamllint}/bin/yamllint";
              };
            }
          ];
        };
        settings = {
          editor = {
            auto-format = true;
            bufferline = "always";
            color-modes = true;
            cursor-shape = {
              normal = "block";
              insert = "bar";
              select = "underline";
            };
            cursorcolumn = true;
            cursorline = true;
            file-picker = {
              # Display hidden files in file picker
              hidden = false;
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
            };
            shell = [ "zsh" "-c" ];
            soft-wrap.enable = true;
            statusline = {
              left = [ "mode" "spinner" "file-name" ];
              right = [ "diagnostics" "selections" "position" "file-type" "file-encoding" ];
            };
            true-color = true;
            whitespace.characters = {
              newline = "↴";
              tab = "⇥";
            };
          };
          keys = {
            normal = {
              space = {
                f = ":format"; # format using LSP formatter
                W = [ ":toggle soft-wrap.enable" ":redraw" ];
              };
              esc = [ "collapse_selection" "keep_primary_selection" ];
              C-k = [ "extend_to_line_bounds" "delete_selection" "move_line_up" "paste_before" ];
              C-j = [ "extend_to_line_bounds" "delete_selection" "paste_after" ];
              C-r = ":reload";
              C-h = ":toggle-option lsp.display-inlay-hints";
              space.space = "file_picker";
              space.w = ":w";
              space.q = ":q";
            };
            select = { };
          };
        };
      };
    };
  };
}
