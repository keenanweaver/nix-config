{ inputs, home-manager, lib, config, username, pkgs, ... }: with lib;
let
  cfg = config.packages;
in
{
  options = {
    packages = {
      enable = mkEnableOption "Enable packages in home-manager";
      dev = mkOption {
        type = types.bool;
        default = true;
      };
      misc = mkOption {
        type = types.bool;
        default = true;
      };
      system = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };
  config = mkIf cfg.enable {
    #nixosConfiguration = { };
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      home.file = {
        powershell-profile = {
          enable = true;
          recursive = false;
          text = ''
            Import-Module Catppuccin
            $Flavor = $Catppuccin['Mocha']
          '';
          target = "${config.xdg.configHome}/powershell/Microsoft.PowerShell_profile.ps1";
        };
      };
      home.packages = with pkgs; [ ] ++ lib.optionals cfg.dev [
        #########
        ## Dev ##
        #########
        codeium
        devbox
        just
        powershell
        ### Ansible ###
        ansible
        ansible-language-server
        ansible-lint
        ## Bash ###
        nodePackages.bash-language-server
        shellcheck
        ### C ###
        clang-tools
        ### Docker ###
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
        python3
        python311Packages.python-lsp-server
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
      ] ++ lib.optionals cfg.misc [
        ##################
        ## Other tools ##
        #################
        projectm
        yq
        ### unix alternatives ###
        dogdns #dig
        dua #du
        duf #df
        fd #find
        pigz #gz
        procs #ps
        sd #sed
        xh #curl
        ## Nix ##
        comma
        manix
        nixd
        nix-init
        nixpkgs-review
        nix-update
        nixos-shell
        nixpkgs-fmt
        nvd
        statix
      ] ++ lib.optionals cfg.system [
        ############
        ## System ##
        ############
        aspell
        aspellDicts.en
        fastfetch
        killall
        libnotify
        kmon
        p7zip
        #pciutils
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
