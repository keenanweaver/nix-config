{
  flake.modules.homeManager.profile-base =
    {
      inputs,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.lazyvim-nix.homeManagerModules.default
      ];
      home.sessionVariables.EDITOR = lib.mkDefault "nvim";
      programs.lazyvim = {
        enable = lib.mkDefault true;
        extraPackages = with pkgs; [
          bash-language-server
          clang
          clang-tools
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
          ruff
          basedpyright
          python3
          rust-analyzer
          vscode-extensions.vadimcn.vscode-lldb
        ];
        extras = {
          ai.claudecode.enable = true;
          coding = {
            blink.enable = true;
            mini-snippets.enable = true;
            mini-surround.enable = true;
            yanky.enable = true;
          };
          dap.core.enable = true;
          editor.overseer.enable = true;
          formatting.prettier.enable = true;
          lang = {
            clangd.enable = true;
            cmake.enable = true;
            docker.enable = true;
            git.enable = true;
            json.enable = true;
            nix.enable = true;
            python.enable = true;
            rust.enable = true;
            terraform.enable = true;
            toml.enable = true;
            yaml.enable = true;
          };
          linting.eslint.enable = true;
          ui.treesitter-context.enable = true;
          util = {
            gh.enable = true;
            mini-hipatterns.enable = true;
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
  flake-file.inputs.lazyvim-nix = {
    inputs = {
      flake-utils.follows = "flake-utils";
      nixpkgs.follows = "nixpkgs";
    };
    url = "github:pfassina/lazyvim-nix";
  };
}
