{
  flake.modules = {
    homeManager.vscodium =
      {
        lib,
        pkgs,
        osConfig,
        ...
      }:
      let
        marketplace-extensions = with pkgs.vscode-marketplace; [
          anthropic.claude-code
          ban.spellright
          christian-kohler.path-intellisense
          eamodio.gitlens
          formulahendry.code-runner
          foxundermoon.shell-format
          jnoortheen.nix-ide
          ms-vscode.powershell
          redhat.vscode-xml
          redhat.vscode-yaml
          tamasfe.even-better-toml
          timonwong.shellcheck
          usernamehw.errorlens
          yzhang.markdown-all-in-one
        ];
      in
      {
        programs.vscodium = {
          enable = true;
          profiles = {
            default = {
              enableExtensionUpdateCheck = false;
              enableUpdateCheck = false;
              extensions =
                marketplace-extensions
                ++ (with pkgs.vscode-extensions; [
                  visualjj.visualjj
                  editorconfig.editorconfig
                ]);
              userSettings =
                let
                  flake = "(builtins.getFlake (builtins.toString ./. ))";
                  host = osConfig.networking.hostName;
                in
                {
                  "[nix]"."editor.defaultFormatter" = "jnoortheen.nix-ide";
                  "[powershell]"."editor.renderControlCharacters" = true;
                  "[powershell]"."editor.renderWhitespace" = "all";
                  "[powershell]"."files.autoGuessEncoding" = true;
                  "[powershell]"."files.trimTrailingWhitespace" = true;
                  "chat.disableAIFeatures" = true;
                  "claudeCode.preferredLocation" = "panel";
                  "codeium.enableConfig"."*" = true;
                  "codeium.enableConfig"."nix" = true;
                  "editor.fontFamily" = "'Maple Mono Normal NF', 'monospace', monospace";
                  "editor.fontLigatures" = true;
                  "editor.fontSize" = 18;
                  "editor.formatOnSave" = false;
                  "editor.inlineSuggest.enabled" = true;
                  "editor.minimap.enabled" = true;
                  "editor.minimap.renderCharacters" = false;
                  "editor.renderControlCharacters" = true;
                  "editor.semanticHighlighting.enabled" = true;
                  "editor.stickyScroll.enabled" = true;
                  "editor.tabCompletion" = "on";
                  "editor.wordWrap" = "on";
                  "files.autoSave" = "onFocusChange";
                  "git.allowForcePush" = true;
                  "git.autofetch" = true;
                  "git.closeDiffOnOperation" = true;
                  "git.confirmSync" = false;
                  "git.enableCommitSigning" = true;
                  "nix.enableLanguageServer" = true;
                  "nix.formatterPath" = lib.getExe pkgs.nixfmt;
                  "nix.serverPath" = lib.getExe pkgs.nixd;
                  "nix.serverSettings" = {
                    "nixd" = {
                      "options" = {
                        "home-manager"."expr" =
                          "${flake}.nixosConfigurations.${host}.options.home-manager.users.type.getSubOptions []";
                        "nixos"."expr" = "${flake}.nixosConfigurations.${host}.options";
                      };
                      "nixpkgs"."expr" = "import ${flake}.inputs.nixpkgs { }";
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
                  "terminal.integrated.shellIntegration.enabled" = true;
                  "update.mode" = "none";
                  "window.titleBarStyle" = "custom";
                  "workbench.editorAssociations"."git-rebase-todo" = "gitlens.rebase";
                  "workbench.sideBar.location" = "right";
                };
            };
          };
        };
      };
    nixos.vscodium = { inputs, ... }: {
      nixpkgs.overlays = [ inputs.nix-vscode-extensions.overlays.default ];
    };
  };
  flake-file.inputs = {
    nix-vscode-extensions = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nix-vscode-extensions";
    };
  };
}
