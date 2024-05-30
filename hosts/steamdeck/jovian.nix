{ lib, username, ... }:
{
  imports = [
    # Profiles
    ../../modules
  ];

  # Custom modules
  desktop.enable = true;
  gaming.enable = true;

  distrobox.enable = lib.mkForce false;

  cdemu.enable = lib.mkForce false;
  corectrl.enable = lib.mkForce false;
  fluidsynth.enable = true;
  gamemode.enable = lib.mkForce false;
  gamescope.enable = lib.mkForce false;
  gpu-screen-recorder.enable = lib.mkForce false;
  mangohud.enable = lib.mkForce false;
  steam.enable = lib.mkForce false;
  timidity.enable = lib.mkForce false;

  jovian = {
    devices.steamdeck = {
      enable = true;
      enableGyroDsuService = true;
      autoUpdate = true;
    };
    steam = {
      enable = true;
      autoStart = true;
      user = "${username}";
      desktopSession = "plasma";
    };
    decky-loader.enable = true;
  };

  home-manager.users.${username} =
    {
      lib,
      config,
      username,
      pkgs,
      ...
    }:
    {
      home.file = {
        script-bootstrap-baremetal-steamdeck = {
          enable = true;
          text = ''
            #!/usr/bin/env bash
            # Set up Distrobox containers
            distrobox assemble create --file ${config.xdg.configHome}/distrobox/distrobox.ini
            distrobox enter bazzite-arch-exodos -- bash -l -c "${config.xdg.configHome}/distrobox/bootstrap-ansible.sh"
            distrobox enter bazzite-arch-gaming -- bash -l -c "${config.xdg.configHome}/distrobox/bootstrap-ansible.sh"
            # Set up flatpaks
            /home/${username}/.local/bin/flatpak-install-all.sh
            curl https://api.github.com/repos/rustdesk/rustdesk/releases/latest | jq -r '.assets[] | select(.name | test(".*flatpak$")).browser_download_url' | wget -i- -N -P /home/${username}/Downloads
            fd 'rustdesk' /home/${username}/Downloads -e flatpak -x flatpak install -u -y
            # Set up other things
            ## SteamTinkerLaunch https://gist.github.com/jakehamilton/632edeb9d170a2aedc9984a0363523d3
            steamtinkerlaunch compat add
            steamtinkerlaunch
            sed -i -e 's/-SKIPINTDEPCHECK="0"/-SKIPINTDEPCHECK="1"/g' ${config.xdg.configHome}/steamtinkerlaunch/global.conf
            ## Conty
            curl https://api.github.com/repos/Kron4ek/conty/releases/latest | jq -r '.assets[] | select(.name | test("conty_lite.sh$")).browser_download_url' | wget -i- -N -P /home/${username}/.local/bin
            chmod +x /home/${username}/.local/bin/conty_lite.sh
            #conty_lite.sh -u
          '';
          target = ".local/bin/bootstrap-baremetal.sh";
          executable = true;
        };
      };
      home.packages = with pkgs; [
        # Fonts
        ibm-plex
        (nerdfonts.override {
          fonts = [
            "JetBrainsMono"
            "IBMPlexMono"
            "RobotoMono"
          ];
        })
        roboto
        roboto-serif
      ];
      services = {
        opensnitch-ui.enable = lib.mkForce false;
      };
      xdg = {
        enable = lib.mkForce false;
        portal = {
          enable = lib.mkForce false;
        };
      };
    };
}
