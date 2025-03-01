{
  inputs,
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.vscode;
  marketplace-extensions =
    with inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace; [
      arrterian.nix-env-selector
      ban.spellright
      #charliermarsh.ruff
      #codeium.codeium
      eamodio.gitlens
      formulahendry.code-runner
      foxundermoon.shell-format
      jnoortheen.nix-ide
      mkhl.direnv
      #ms-python.python
      ms-vscode.powershell
      ms-vscode-remote.remote-containers
      #ms-vscode-remote.remote-ssh
      #redhat.ansible
      redhat.vscode-xml
      redhat.vscode-yaml
      #rust-lang.rust-analyzer
      skellock.just
      #s-nlf-fh.glassit
      #sumneko.lua
      tamasfe.even-better-toml
      timonwong.shellcheck
      usernamehw.errorlens
      yzhang.markdown-all-in-one
    ];
in
{
  options = {
    vscode = {
      enable = lib.mkEnableOption "Enable vscode in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} =
      { pkgs, ... }:
      {
        nixpkgs = {
          overlays = [ inputs.nix-vscode-extensions.overlays.default ];
        };
        programs.vscode = {
          enable = true;
          package = pkgs.vscodium;
          profiles = {
            default = {
              enableExtensionUpdateCheck = false;
              enableUpdateCheck = false;
              extensions = marketplace-extensions ++ [
                pkgs.vscode-extensions.visualjj.visualjj
                pkgs.vscode-extensions.editorconfig.editorconfig
              ];
              userSettings = {
                "ansible.ansible.path" = "${pkgs.ansible}/bin/ansible";
                "ansible.python.interpreterPath" = "python";
                "ansible.validation.lint.path" = "${pkgs.ansible-lint}/bin/ansible-lint";
                "codeium.enableConfig"."*" = true;
                "codeium.enableConfig"."nix" = true;
                "editor.formatOnSave" = false;
                "editor.inlineSuggest.enabled" = true;
                "editor.minimap.enabled" = true;
                "editor.minimap.renderCharacters" = false;
                "editor.renderControlCharacters" = true;
                "editor.semanticHighlighting.enabled" = true;
                "editor.tabCompletion" = "on";
                "editor.wordWrap" = "on";
                "git.allowForcePush" = true;
                "git.autofetch" = true;
                "git.confirmSync" = false;
                "git.enableCommitSigning" = true;
                "gopls"."ui.semanticTokens" = true;
                "[nix]"."editor.defaultFormatter" = "jnoortheen.nix-ide";
                "nix.enableLanguageServer" = true;
                "nix.formatterPath" = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
                "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
                "nix.serverSettings"."nixd"."formatting"."command" = [ "nixfmt" ];
                "nix.serverSettings"."nixd"."formatting"."options" = {
                  "enable" = [ true ];
                };
                "powershell.powerShellAdditionalExePaths"."exePath" = "${pkgs.powershell}/bin/pwsh";
                "powershell.integratedConsole.focusConsoleOnExecute" = false;
                "powershell.integratedConsole.showOnStartup" = false;
                "[powershell]"."editor.renderControlCharacters" = true;
                "[powershell]"."editor.renderWhitespace" = "all";
                "[powershell]"."files.autoGuessEncoding" = true;
                "[powershell]"."files.trimTrailingWhitespace" = true;
                "[python]"."editor.defaultFormatter" = "charliermarsh.ruff";
                "redhat.telemetry.enabled" = false;
                "security.workspace.trust.enabled" = false;
                "terminal.integrated.minimumContrastRatio" = 1;
                "terminal.integrated.shellIntegration.enabled" = true;
                "window.titleBarStyle" = "custom";
                "workbench.editorAssociations"."git-rebase-todo" = "gitlens.rebase";
                "workbench.sideBar.location" = "right";
              };
            };
          };
        };
      };
  };
}
