{ username, ... }:
{
  imports = [
    # Profiles
    ../../modules
  ];

  # Custom modules
  desktop.enable = true;
  gaming.enable = true;

  home-manager.users.${username} =
    { config, username, ... }:
    {
      home.file = {
        script-bootstrap-baremetal-desktop = {
          enable = true;
          text = ''
            #!/usr/bin/env bash
            # Set up Distrobox containers
            distrobox assemble create --file ${config.xdg.configHome}/distrobox/distrobox.ini
            distrobox enter bazzite-arch-exodos -- bash -l -c "${config.xdg.configHome}/distrobox/bootstrap-ansible.sh"
            distrobox enter bazzite-arch-gaming -- bash -l -c "${config.xdg.configHome}/distrobox/bootstrap-ansible.sh"
            distrobox enter bazzite-arch-sys -- bash -l -c "${config.xdg.configHome}/distrobox/bootstrap-ansible.sh"
            # Set up flatpaks
            sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
            flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
            /home/${username}/.local/bin/flatpak-install-all.sh
            curl https://api.github.com/repos/rustdesk/rustdesk/releases/latest | jq -r '.assets[] | select(.name | test(".*flatpak$")).browser_download_url' | wget -i- -N -P /home/${username}/Downloads
            fd 'rustdesk' /home/${username}/Downloads -e flatpak -x flatpak install -u -y
            # Set up other things
            ## SteamTinkerLaunch https://gist.github.com/jakehamilton/632edeb9d170a2aedc9984a0363523d3
            steamtinkerlaunch compat add
            steamtinkerlaunch
            sed -i -e 's/-SKIPINTDEPCHECK="0"/-SKIPINTDEPCHECK="1"/g' ${config.xdg.configHome}/steamtinkerlaunch/global.conf
            ## SheepShaver
            curl https://api.github.com/repos/Korkman/macemu-appimage-builder/releases/latest | jq -r '.assets[] | select(.name | test("x86_64.AppImage$")).browser_download_url' | wget -i- -N -P /home/${username}/.local/bin
            ## MoonDeck Buddy
            curl https://api.github.com/repos/FrogTheFrog/moondeck-buddy/releases/latest | jq -r '.assets[] | select(.name | test("x86_64.AppImage$")).browser_download_url' | wget -i- -N -P /home/${username}/.local/bin
            ## Conty
            curl https://api.github.com/repos/Kron4ek/conty/releases/latest | jq -r '.assets[] | select(.name | test("conty_lite.sh$")).browser_download_url' | wget -i- -N -P /home/${username}/.local/bin
            chmod +x /home/${username}/.local/bin/conty_lite.sh
            #conty_lite.sh -u
          '';
          target = ".local/bin/bootstrap-baremetal.sh";
          executable = true;
        };
      };
      xdg = {
        desktopEntries = {
          foobar2000 = {
            name = "foobar2000";
            comment = "Launch foobar2000 using Bottles.";
            exec = "bottles-cli run -p foobar2000 -b foobar2000";
            icon = "/home/${username}/Games/Bottles/foobar2000/icons/foobar2000.png";
            categories = [
              "AudioVideo"
              "Player"
              "Audio"
            ];
            noDisplay = false;
            startupNotify = true;
            actions = {
              "Configure" = {
                name = "Configure in Bottles";
                exec = "bottles -b foobar2000";
              };
            };
            settings = {
              StartupWMClass = "foobar2000";
            };
          };
          qobuz = {
            name = "Qobuz";
            comment = "Launch Qobuz using Bottles.";
            exec = "bottles-cli run -p Qobuz -b Qobuz";
            icon = "/home/${username}/Games/Bottles/Qobuz/icons/Qobuz.png";
            categories = [
              "AudioVideo"
              "Player"
              "Audio"
            ];
            noDisplay = false;
            startupNotify = true;
            actions = {
              "Configure" = {
                name = "Configure in Bottles";
                exec = "bottles -b Qobuz";
              };
            };
            settings = {
              StartupWMClass = "Qobuz";
            };
          };
        };
      };
    };
}
