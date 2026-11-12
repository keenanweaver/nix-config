{ self, ... }:
let
  inherit (self.lib) packageListText;
in
{
  flake.modules = {
    homeManager.profile-base =
      { config, pkgs, ... }:
      {
        home.packages = with pkgs; [
          (_7zz.override { enableUnfree = true; })
          aspell
          aspellDicts.en
          killall
          kmon
          repgrep
          unrar
          unzip
          usbutils
          viu
          wget
          zip
        ];
        programs = {
          atuin.enable = true;
          bat = {
            enable = true;
            extraPackages = with pkgs.bat-extras; [
              batdiff
              batgrep
              batman
              batpipe
            ];
          };
          btop.enable = true;
          direnv = {
            enable = true;
            silent = true;
          };
          fd = {
            enable = true;
            extraOptions = [
              "--no-ignore"
              "--absolute-path"
            ];
            hidden = true;
            ignores = [ ".git/" ];
          };
          fzf = {
            enable = true;
            defaultCommand = "fd --type f";
            fileWidget.options = [ "--preview bat -pp --color=always {}" ];
            historyWidget.command = "";
          };
          jq.enable = true;
          lazygit = {
            enable = true;
            settings = {
              git.overrideGpg = true;
              gui.mouseEvents = false;
              promptToReturnFromSubprocess = false;
            };
          };
          nix-init.enable = true;
          nix-your-shell = {
            enable = true;
            nix-output-monitor.enable = true;
          };
          nushell = {
            enable = true;
            loadSessionVariables = true;
          };
          rclone.enable = true;
          ripgrep = {
            enable = true;
            arguments = [ "-uuu" ];
          };
          tealdeer = {
            enable = true;
            settings.display = {
              compact = false;
              use_pager = false;
            };
          };
          zoxide.enable = true;
        };
        xdg.configFile.packages-hm.text = packageListText pkgs config.home.packages;
      };
    nixos.profile-base =
      { config, pkgs, ... }:
      {
        environment.etc.packages.text = packageListText pkgs config.environment.systemPackages;
      };
  };
}
