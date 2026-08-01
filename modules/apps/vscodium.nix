{
  flake.modules = {
    homeManager.vscodium =
      {
        lib,
        pkgs,
        osConfig,
        ...
      }:
      {
        programs.vscodium = {
          enable = true;
          enableMcpIntegration = true;

          profiles.default = {
            enableExtensionUpdateCheck = false;
            enableUpdateCheck = false;

            extensions =
              (with pkgs.vscode-marketplace; [
                anthropic.claude-code
                ban.spellright
                christian-kohler.path-intellisense
                Codeium.codeium
                eamodio.gitlens
                formulahendry.code-runner
                foxundermoon.shell-format
                jnoortheen.nix-ide
                mkhl.direnv
                ms-vscode.powershell
                redhat.vscode-xml
                redhat.vscode-yaml
                tamasfe.even-better-toml
                timonwong.shellcheck
                usernamehw.errorlens
                yzhang.markdown-all-in-one
              ])
              ++ (with pkgs.vscode-extensions; [
                editorconfig.editorconfig
                visualjj.visualjj
              ]);

            userSettings =
              let
                flake = "(builtins.getFlake (builtins.toString ./. ))";
                host = osConfig.networking.hostName;
              in
              {
                "[nix]"."editor.defaultFormatter" = "jnoortheen.nix-ide";
                "chat.disableAIFeatures" = true;
                "claudeCode.preferredLocation" = "panel";

                "codeium.enableConfig" = {
                  "*" = true;
                  "nix" = true;
                };

                "diffEditor.ignoreTrimWhitespace" = false;
                "editor.bracketPairColorization.enabled" = true;
                "editor.cursorBlinking" = "smooth";
                "editor.fontFamily" = "'Maple Mono Normal NF', 'monospace', monospace";
                "editor.fontLigatures" = true;
                "editor.fontSize" = 18;
                "editor.formatOnSave" = false;
                "editor.guides.bracketPairs" = "active";
                "editor.linkedEditing" = true;
                "editor.minimap.renderCharacters" = false;
                "editor.renderControlCharacters" = true;

                "editor.rulers" = [
                  80
                  120
                ];

                "editor.semanticHighlighting.enabled" = true;
                "editor.tabCompletion" = "on";
                "editor.wordWrap" = "on";
                "files.autoSave" = "onFocusChange";
                "files.insertFinalNewline" = true;
                "files.trimFinalNewlines" = true;
                "git.allowForcePush" = true;
                "git.autofetch" = true;
                "git.closeDiffOnOperation" = true;
                "git.confirmSync" = false;
                "git.enableCommitSigning" = true;
                "nix.enableLanguageServer" = true;
                "nix.formatterPath" = lib.getExe pkgs.nixfmt;
                "nix.serverPath" = lib.getExe pkgs.nixd;

                "nix.serverSettings"."nixd" = {
                  "nixpkgs"."expr" = "import ${flake}.inputs.nixpkgs { }";

                  "options" = {
                    "home-manager"."expr" =
                      "${flake}.nixosConfigurations.${host}.options.home-manager.users.type.getSubOptions []";

                    "nixos"."expr" = "${flake}.nixosConfigurations.${host}.options";
                  };
                };

                "powershell.integratedConsole.focusConsoleOnExecute" = false;
                "powershell.integratedConsole.showOnStartup" = false;
                "powershell.powerShellAdditionalExePaths"."exePath" = lib.getExe pkgs.powershell;
                "security.workspace.trust.enabled" = false;
                "telemetry.telemetryLevel" = "off";
                "terminal.integrated.fontFamily" = "Maple Mono Normal NF";
                "terminal.integrated.fontSize" = 14;
                "terminal.integrated.fontWeight" = "normal";
                "terminal.integrated.minimumContrastRatio" = 1;
                "terminal.integrated.scrollback" = 10000;
                "update.mode" = "none";
                "window.menuBarVisibility" = "toggle";
                "window.titleBarStyle" = "custom";
                "workbench.editor.enablePreview" = false;
                "workbench.editorAssociations"."git-rebase-todo" = "gitlens.rebase";
                "workbench.sideBar.location" = "right";
                "workbench.startupEditor" = "none";
              };
          };
        };
      };

    nixos.vscodium =
      { inputs, ... }:
      {
        nixpkgs.overlays = [ inputs.nix-vscode-extensions.overlays.default ];
      };
  };

  flake-file.inputs.nix-vscode-extensions = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:nix-community/nix-vscode-extensions";
  };
}
