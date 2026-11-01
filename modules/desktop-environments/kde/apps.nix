{ config, ... }:
let
  inherit (config.site.network) lanSubnet;
  range = {
    from = 1714;
    to = 1764;
  };
in
{
  flake.modules = {
    homeManager.plasma-manager =
      {
        lib,
        config,
        pkgs,
        osConfig,
        ...
      }:
      {
        programs = {
          kate = {
            enable = true;
            editor.brackets = {
              automaticallyAddClosing = true;
              flashMatching = true;
              highlightMatching = true;
              highlightRangeBetween = true;
            };
            lsp.customServers = {
              bash = {
                command = [
                  (lib.getExe pkgs.bash-language-server)
                  "start"
                ];
                highlightingModeRegex = "^Bash$";
                settings.bashIde.shellcheckPath = lib.getExe pkgs.shellcheck;
                url = "https://github.com/bash-lsp/bash-language-server";
              };
              dockerfile = {
                command = [
                  (lib.getExe pkgs.dockerfile-language-server)
                  "--stdio"
                ];
                highlightingModeRegex = "^Dockerfile$";
                settings.docker.languageserver.diagnostics.instructionCasing = "warning";
                url = "https://github.com/rcjsuen/dockerfile-language-server";
              };
              json = {
                command = [
                  (lib.getExe pkgs.vscode-json-languageserver)
                  "--stdio"
                ];
                highlightingModeRegex = "^JSON$";
                url = "https://github.com/microsoft/vscode/tree/main/extensions/json-language-features/server";
              };
              lua = {
                command = [ (lib.getExe pkgs.lua-language-server) ];
                highlightingModeRegex = "^Lua$";
                settings.Lua = {
                  telemetry.enable = false;
                  workspace.checkThirdParty = false;
                };
                url = "https://github.com/LuaLS/lua-language-server";
              };
              markdown = {
                command = [
                  (lib.getExe pkgs.marksman)
                  "server"
                ];
                highlightingModeRegex = "^Markdown$";
                url = "https://github.com/artempyanykh/marksman";
              };
              nix = {
                command = [ (lib.getExe pkgs.nixd) ];
                highlightingModeRegex = "^Nix$";
                settings.nixd = {
                  formatting.command = [
                    (lib.getExe pkgs.nixfmt)
                    "-"
                  ];
                  options.nixos.expr = ''(builtins.getFlake "${config.programs.nh.flake}").nixosConfigurations."${osConfig.networking.hostName}".options'';
                };
                url = "https://github.com/nix-community/nixd";
              };
              rust = {
                command = [ (lib.getExe pkgs.rust-analyzer) ];
                highlightingModeRegex = "^Rust$";
                settings.rust-analyzer.check.command = "clippy";
                url = "https://rust-analyzer.github.io/";
              };
              toml = {
                command = [
                  (lib.getExe pkgs.taplo)
                  "lsp"
                  "stdio"
                ];
                highlightingModeRegex = "^TOML$";
                url = "https://taplo.tamasfe.dev/";
              };
              xml = {
                command = [ (lib.getExe pkgs.lemminx) ];
                highlightingModeRegex = "^XML$";
                url = "https://github.com/redhat-developer/lemminx";
              };
              yaml = {
                command = [
                  (lib.getExe pkgs.yaml-language-server)
                  "--stdio"
                ];
                highlightingModeRegex = "^YAML$";
                url = "https://github.com/redhat-developer/yaml-language-server";
              };
            };
          };
          konsole = {
            enable = true;
            defaultProfile = "${osConfig.my.user}";
            extraConfig = {
              KonsoleWindow.RemoveWindowTitleBarAndFrame = true;
              MainWindow.MenuBar = "Disabled";
            };
            profiles = {
              "${osConfig.my.user}".command = lib.getExe pkgs.zsh;
            };
          };
          okular = {
            enable = true;
            general = {
              obeyDrm = false;
              openFileInTabs = true;
              showScrollbars = true;
              smoothScrolling = true;
              viewMode = "Facing";
              zoomMode = "fitWidth";
            };
            performance.enableTransparencyEffects = true;
          };
          plasma.configFile.katerc = {
            ColoredBrackets = {
              color1 = "#f38ba8";
              color2 = "#fab387";
              color3 = "#a6e3a1";
              color4 = "#74c7ec";
              color5 = "#b4befe";
            };
            "Kate Plugins".rainbowparens = true;
          };
        };
        xdg.configFile."kate/formatting/settings.json".text = builtins.toJSON {
          nixfmt.command = [
            (lib.getExe pkgs.nixfmt)
            "-"
          ];
        };
      };
    nixos.kde =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.kdePackages.kdeconnect-kde ];
        networking.firewall = {
          extraInputRules = ''
            ip saddr ${lanSubnet} tcp dport ${toString range.from}-${toString range.to} accept
            ip saddr ${lanSubnet} udp dport ${toString range.from}-${toString range.to} accept
          '';
          interfaces.tailscale0 = {
            allowedTCPPortRanges = [ range ];
            allowedUDPPortRanges = [ range ];
          };
        };
      };
  };
}
