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
      etc."packages".text =
        let
          packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
          sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
          formatted = builtins.concatStringsSep "\n" sortedUnique;
        in
        formatted;
    };
    nixpkgs.config.permittedInsecurePackages = [
      "olm-3.2.16" # Neochat
    ];
    programs = {
      appimage = {
        enable = true;
        binfmt = true;
      };
      iotop = {
        enable = true;
      };
    };
    home-manager.users.${username} =
      {
        lib,
        pkgs,
        config,
        ...
      }:
      {
        home.file = {
          current-packages = {
            enable = true;
            text =
              let
                packages = builtins.map (p: "${p.name}") config.home.packages;
                sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
                formatted-hm = builtins.concatStringsSep "\n" sortedUnique;
              in
              formatted-hm;
            target = "${config.xdg.configHome}/packages-hm";
          };
        };
        home.packages =
          with pkgs;
          [ ]
          ++ lib.optionals cfg.dev [
            codeium
            devenv
            just
            powershell
            seer
            ### Ansible ###
            ansible
            ansible-language-server
            ansible-lint
            ## Bash ###
            bash-language-server
            shellcheck
            shellharden
            shfmt
            ## Clang ##
            clang-tools
            qtcreator
            ### Docker ###
            #docker-compose-language-service
            #dockerfile-language-server-nodejs
            ### HTML / CSS / JSON ###
            #vscode-langservers-extracted
            ### Lua ###
            #lua-language-server
            ### Python ###
            #black
            #ruff
            #ruff-lsp
            ### Markdown ###
            marksman
            ### Terraform ###
            #terraform-ls
            ### TOML ###
            #taplo-lsp
            ### YAML ###
            #nodePackages.yaml-language-server
            #yamllint
            ### XML ###
            #lemminx
          ]
          ++ lib.optionals cfg.misc [
            adguardian
            angle-grinder
            bandwhich
            binsider
            csvlens
            flawz
            glances
            glow
            gping
            hexyl
            hyperfine
            impala
            isd
            jiq
            lazyjournal
            magic-wormhole-rs
            mkvtoolnix-cli
            play
            podman-tui
            streamrip
            systemctl-tui
            termscp
            ttysvr
            wikiman
            yq
            ## unix alts ##
            choose # cut
            dogdns # dig
            dua # du
            duf # df
            fuc # cp / rm
            ouch # compression
            pigz # gz
            procs # ps
            sd # sed
            writedisk # dd
            xh # curl
            ## Nix ##
            comma
            manix
            nixd
            nix-init
            nix-inspect
            nix-update
            nixfmt-rfc-style
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
