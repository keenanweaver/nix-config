{
  lib,
  inputs,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.packages;
in
{
  options = {
    packages = {
      enable = lib.mkEnableOption "Enable packages in home-manager";
      dev = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      misc = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      system = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    environment = {
      # Writes current *system* packages to /etc/current-system/packages
      etc."packages".text =
        let
          packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
          sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
          formatted = builtins.concatStringsSep "\n" sortedUnique;
        in
        formatted;
    };
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
    home-manager.users.${username} =
      { lib, pkgs, ... }:
      {
        home.packages =
          with pkgs;
          [ ]
          ++ lib.optionals cfg.dev [
            codeium
            devbox
            just
            powershell
            ### Ansible ###
            ansible
            ansible-language-server
            ansible-lint
            ## Bash ###
            bash-language-server
            shellcheck
            ### C ###
            clang-tools
            cmake-language-server
            ### Docker ###
            docker-compose-language-service
            dockerfile-language-server-nodejs
            ### Go ###
            gofumpt
            gopls
            gotools
            #go
            delve
            ### HTML / CSS / JSON ###
            vscode-langservers-extracted
            ### Javascript ###
            nodePackages.typescript-language-server
            #nodePackages.vscode-json-languageserver
            ### Lua ###
            lua-language-server
            ### Python ###
            black
            #python3
            #python311Packages.python-lsp-server
            ruff
            ruff-lsp
            ### Rust ###
            rustup
            ### Markdown ###
            marksman
            ### Terraform ###
            terraform-ls
            ### TOML ###
            taplo-lsp
            ### YAML ###
            nodePackages.yaml-language-server
            yamllint
            ### XML ###
            lemminx
          ]
          ++ lib.optionals cfg.misc [
            angle-grinder
            glow
            hexyl
            hyperfine
            jiq
            jq
            lazydocker
            mkvtoolnix-cli
            okteta
            projectm
            rustdesk-flutter
            streamrip
            yq
            ### unix alternatives ###
            choose # cut
            dogdns # dig
            dua # du
            duf # df
            ouch # compression
            pigz # gz
            procs # ps
            rclone # rsync
            sd # sed
            writedisk # dd
            xh # curl
            ## Nix ##
            comma
            inputs.nsearch.packages.${pkgs.system}.default
            manix
            nixd
            nix-init
            nix-update
            nixfmt-rfc-style
            nixpkgs-review
            nixos-shell
            (writeShellApplication {
              name = "nos";
              runtimeInputs = [
                coreutils
                fzf
                optinix
                ripgrep
              ];
              text = ''
                optinix get --no-tui | rg 'Name: ' | cut -d' ' -f2 | fzf --preview='optinix get --no-tui "{}"'
              '';
            })
            (writeShellApplication {
              name = "nps";
              runtimeInputs = [
                fzf
                inputs.nsearch.packages.${pkgs.system}.default
              ];
              text = ''
                export NSEARCH_FZF_CMD="fzf --multi --bind=ctrl-space:select --bind=alt-space:deselect"
                nsearch
              '';
            })
            nvd
            optinix
            statix
          ]
          ++ lib.optionals cfg.system [
            (_7zz.override { enableUnfree = true; })
            aspell
            aspellDicts.en
            killall
            libnotify
            kmon
            p7zip
            repgrep
            unrar
            unzip
            usbutils
            viu
            wget
            xclip
            zip
          ];
      };
  };
}
