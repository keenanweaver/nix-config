{
  flake.modules.nixos.profile-workstation =
    { config, pkgs, ... }:
    {
      environment = {
        sessionVariables.DOCKER_HOST = "unix://\${XDG_RUNTIME_DIR}/podman/podman.sock";
        systemPackages = with pkgs; [
          podlet
          quickemu
          spice
          virtio-win
          virtiofsd
          win-spice
        ];
      };
      networking.firewall.trustedInterfaces = [ "virbr0" ];
      nix-mineral.settings.network.ip-forwarding = true;
      preservation.preserveAt."/persist".directories = [
        "/var/lib/containers"
        "/var/lib/libvirt"
        "/var/lib/qemu"
      ];
      programs.virt-manager.enable = true;
      systemd.tmpfiles.rules = [ "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware" ];
      users.users = {
        ${config.my.user}.extraGroups = [
          "kvm"
          "libvirtd"
        ];
      };
      virtualisation = {
        containers.enable = true;
        libvirtd = {
          # Make sure you run this once: "sudo virsh net-autostart default"
          enable = true;
          qemu = {
            swtpm.enable = true;
            vhostUserPackages = with pkgs; [ virtiofsd ];
          };
        };
        podman = {
          enable = true;
          defaultNetwork.settings.dns_enabled = true;
          dockerCompat = true;
        };
        spiceUSBRedirection.enable = true;
        vmVariant = {
          services = {
            qemuGuest.enable = true;
            spice-vdagentd.enable = true;
          };
          virtualisation = {
            cores = 3;
            memorySize = 4096;
          };
        };
      };
    };
}
