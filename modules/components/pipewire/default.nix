{ inputs, home-manager, lib, config, username, dotfiles, ... }: with lib;
let
  cfg = config.pipewire;
in
{
  options = {
    pipewire = {
      enable = mkEnableOption "Enable pipewire in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    hardware.pulseaudio.enable = false;

    services.pipewire = {
      enable = true;
      audio.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    sound.enable = false;
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      home.file = {
        pipewire-coupled-streams = {
          enable = true;
          recursive = false;
          source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/pipewire/10-coupled-streams.conf";
          target = "${config.xdg.configHome}/pipewire/pipewire.conf.d/10-coupled-streams.conf";
        };
        pipewire-allowed-rates = {
          enable = true;
          recursive = false;
          source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/pipewire/10-allowed-rates.conf";
          target = "${config.xdg.configHome}/pipewire/pipewire.conf.d/10-allowed-rates.conf";
        };
        pipewire-pulseaudio-wine = {
          # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/3537#note_2148169
          enable = true;
          recursive = false;
          source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/pipewire/10-wine-latency.conf";
          target = "${config.xdg.configHome}/pipewire/pipewire-pulse.conf.d/10-wine-latency.conf";
        };
        wireplumber-alsa-config = {
          enable = true;
          recursive = false;
          source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/wireplumber/50-alsa-config.lua";
          target = "${config.xdg.configHome}/wireplumber/main.lua.d/50-alsa-config.lua";
        };
      };
    };
  };
}
