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
      ##arrterian.nix-env-selector
      ban.spellright
      #charliermarsh.ruff
      #codeium.codeium
      eamodio.gitlens
      formulahendry.code-runner
      foxundermoon.shell-format
      jnoortheen.nix-ide
      llvm-vs-code-extensions.vscode-clangd
      ##mkhl.direnv
      #ms-python.python
      ms-vscode.powershell
      #ms-vscode-remote.remote-containers
      #ms-vscode-remote.remote-ssh
      #redhat.ansible
      redhat.vscode-xml
      redhat.vscode-yaml
      #rust-lang.rust-analyzer
      ##skellock.just
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
    nixpkgs = {
      overlays = [ inputs.nix-vscode-extensions.overlays.default ];
    };
    home-manager.users.${username} =
      { pkgs, ... }:
      {
        programs.vscode = {
          enable = true;
          package = pkgs.vscodium;
          profiles = {
            default = {
              enableExtensionUpdateCheck = false;
              enableUpdateCheck = false;
              extensions =
                with pkgs.vscode-extensions;
                marketplace-extensions
                ++ [
                  visualjj.visualjj
                  editorconfig.editorconfig
                ];
              userSettings = {
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
                "[nix]"."editor.defaultFormatter" = "jnoortheen.nix-ide";
                "nix.enableLanguageServer" = true;
                "nix.formatterPath" = "nixfmt";
                "nix.serverPath" = lib.getExe pkgs.nixd;
                "nix.serverSettings"."nixd"."formatting"."command" = [ "nixfmt" ];
                "nix.serverSettings"."nixd"."formatting"."options" = {
                  "enable" = [ true ];
                };
                "powershell.powerShellAdditionalExePaths"."exePath" = lib.getExe pkgs.powershell;
                "powershell.integratedConsole.focusConsoleOnExecute" = false;
                "powershell.integratedConsole.showOnStartup" = false;
                "[powershell]"."editor.renderControlCharacters" = true;
                "[powershell]"."editor.renderWhitespace" = "all";
                "[powershell]"."files.autoGuessEncoding" = true;
                "[powershell]"."files.trimTrailingWhitespace" = true;
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
