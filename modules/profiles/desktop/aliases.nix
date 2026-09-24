{ config, ... }:
let
  inherit (config.flake.lib.site) nas;
in
{
  flake.modules.homeManager.profile-desktop.home.shellAliases = {
    lgog = "lgogdownloader --download --exclude l,p --platform=w --directory ${nas.paths.gogBackups}";
    npr = "nixpkgs-review pr --print-result";
    psr = "plasmashell --replace & disown";
    repw = "systemctl --user restart pipewire{,-pulse} wireplumber && gsr-ui-cli toggle-replay && gsr-ui-cli toggle-replay";
  };
}
