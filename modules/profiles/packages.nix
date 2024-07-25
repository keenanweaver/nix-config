{
  lib,
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
            jq
            projectm
            streamrip
            yq
            ### unix alternatives ###
            dogdns # dig
            dua # du
            duf # df
            ouch # compression
            pigz # gz
            procs # ps
            sd # sed
            xh # curl
            ## Nix ##
            comma
            manix
            nixd
            nix-init
            nix-update
            nixfmt-rfc-style
            #nixpkgs-fmt
            nixpkgs-review
            nixos-shell
            nvd
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
